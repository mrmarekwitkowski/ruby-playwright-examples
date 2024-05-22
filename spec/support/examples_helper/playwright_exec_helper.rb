# frozen_string_literal: true

module ExamplesHelper
  class << self
    def playwright_exec_helper(browser: :chromium, headless: false)
      @playwright_exec_helper ||= PlaywrightExecHelper.new(browser:, headless:)
    end
  end

  class PlaywrightExecHelper
    def initialize(browser: :chromium, headless: false)
      @browser_name = browser.to_sym
      @headless = headless
    end

    def playwright_exec
      @playwright_exec ||= Playwright.create(playwright_cli_executable_path: 'npx playwright')
    end

    def playwright
      @playwright ||= playwright_exec.playwright
    end

    def browser
      @browser ||= playwright.send(@browser_name).launch(headless: @headless)
    end
  end
end
