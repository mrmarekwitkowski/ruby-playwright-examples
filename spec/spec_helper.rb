# frozen_string_literal: true

# require rubygems
require 'pry'
require 'playwright'
require 'playwright/test'

# require support code
require_relative 'support/examples_helper'
require_relative 'support/pages/generic_base_page'
require_relative 'support/pages/todo_page'

RSpec.configure do |config|
  # include Playwright matchers, e.g.
  #   expect(locator).to be_visible
  #   expect(locator).to be_checked
  #   etc...
  config.include Playwright::Test::Matchers

  # including the ExamplesHelper here results in all methods being available in all examples
  config.include ExamplesHelper

  # create a PlaywrightExecHelper instance once before specs are running
  config.before(:suite) do
    browser = ENV.key?('BROWSER') ? ENV.fetch('BROWSER') : 'chromium'

    ExamplesHelper.playwright_exec_helper(browser:, headless: ENV.key?('HEADLESS'))
  end

  config.before(:all) do
    @playwright_exec = ExamplesHelper.playwright_exec_helper.playwright_exec
    @playwright = ExamplesHelper.playwright_exec_helper.playwright
    @browser = ExamplesHelper.playwright_exec_helper.browser
  end

  # generic base config for each example
  config.before(:example) do
    @page = @browser.new_page
  end

  # config for spec/playwright-demo-examples
  config.before(:example, todo_page: true) do
    @page.goto('https://demo.playwright.dev/todomvc')
    @todo_page = TodoPage.new(@page)
    @todos = ['buy some cheese', 'feed the cat', 'book doctors appointment']
  end

  # close the browser page
  config.after(:example) do
    @page.close
  end
end

# Make sure to stop Playwright browser and exec instances
at_exit do
  ExamplesHelper.playwright_exec_helper.browser.close
  ExamplesHelper.playwright_exec_helper.playwright_exec.stop
end
