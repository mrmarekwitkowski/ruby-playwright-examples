# frozen_string_literal: true

RSpec.describe 'Example tests' do
  context 'Visit the Playwright page' do
    it 'validate page title' do
      @page.goto('https://playwright.dev/')
      expect(@page.title).to match(/Playwright/)
    end
  end
end
