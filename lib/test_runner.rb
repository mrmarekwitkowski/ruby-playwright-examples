# frozen_string_literal: true

require 'async'
require 'thor'

module TestRunner
  class CLI < Thor::Group
    include Thor::Actions

    namespace :tests

    class_option :files, aliases: ['-f'], type: :string, default: 'spec/'
    class_option :spec_config, aliases: ['--sc'], type: :string, default: ''
    class_option :tags, aliases: ['-t'], default: [], repeatable: true
    class_option :workers, aliases: ['-w'], type: :numeric, default: 1
    class_option :browser, aliases: ['-b'], type: :string, default: 'chromium'
    class_option :headless, type: :boolean, default: false
    class_option :rspec_options, aliases: ['--ro'], repeatable: true
    class_option :parallel_rspec_options, aliases: ['--pro'], default: [], repeatable: true

    class_option :async, type: :boolean, default: false
    class_option :async_browsers, type: :array, default: %w[chromium firefox webkit]

    def start_time
      @start_time = Time.now
    end

    def run_tests
      return if options[:async]

      ENV['BROWSER'] = options[:browser]
      ENV['HEADLESS'] = options[:headless] ? '1' : nil

      cmd = parallel? ? parallel_cmd : sequential_cmd
      @success = run(cmd)
    end

    # Run tests with option '--async'
    def run_async_tests
      return unless options[:async]

      tasks = Async do |task|
        options[:async_browsers].map do |browser|
          ENV['BROWSER'] = browser
          ENV['HEADLESS'] = options[:headless] ? '1' : nil

          cmd = create_async_cmd(browser)
          task.async { run(cmd) }
        end
      end.wait

      errors = tasks.select { |t| t.result == false }
      @success = errors.empty?
    end

    def finish_test_run
      duration = Time.now - @start_time
      say("Finished running tests in #{duration} seconds!", Color::BOLD)

      exit(1) unless @success
    end

    no_commands do

      # Config files, tags, etc... are part of the RSpec options.
      # When running parallel_rspec, they are part of the '--test-options' option
      # and should be put into single quotes.
      def rspec_options
        str = ''
        str += " --options #{spec_config}"
        options[:tags].each { |tag| str += " -t #{tag}" } if tags?
        options[:rspec_options]&.each { |opt| str += " #{opt}" }
        str
      end

      def parallel_cmd
        base_cmd = 'parallel_rspec'.dup
        base_cmd << " -n #{options[:workers]}"
        base_cmd << " --test-options '#{rspec_options}'"
        base_cmd << " -- #{options[:files]}"
      end

      def sequential_cmd
        base_cmd = 'rspec'.dup
        base_cmd << rspec_options
        base_cmd << " #{options[:files]}"
      end

      # When running tests async the BROWSER env variable must be unique to each command.
      def create_async_cmd(browser)
        cmd = parallel? ? parallel_cmd : sequential_cmd
        cmd.prepend("BROWSER='#{browser}' ")
      end

      def async_config
        '.rspec_async'
      end

      def default_config
        parallel? ? '.rspec_parallel' : '.rspec'
      end

      def spec_config
        return async_config if async?

        options[:spec_config].empty? ? default_config : options[:spec_config]
      end

      def async?
        options[:async]
      end

      def parallel?
        options[:workers] > 1
      end

      def tags?
        options[:tags].any?
      end
    end
  end
end
