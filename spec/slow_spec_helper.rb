# frozen_string_literal: true

# Please do not use the configuration below as it will significantly slow down your execution times.
# It only exists for demonstration purposes.

require 'playwright'
require 'playwright/test'

require_relative 'support/examples_helper'
require_relative 'support/pages/generic_base_page'
require_relative 'support/pages/todo_page'

RSpec.configure do |config|
  config.include Playwright::Test::Matchers
  config.include ExamplesHelper

  config.before(:all) do
    @playwright_exec = Playwright.create(playwright_cli_executable_path: 'npx playwright')
    @playwright = @playwright_exec.playwright
    @browser = @playwright.chromium.launch(headless: false)
  end

  config.before(:example) do
    @page = @browser.new_page

    @page.goto('https://demo.playwright.dev/todomvc')
    @todo_page = TodoPage.new(@page)
    @todos = ['buy some cheese', 'feed the cat', 'book doctors appointment']
  end

  config.after(:example) do
    @page.close
  end

  config.after(:all) do
    @browser.close
    @playwright_exec.stop
  end
end
