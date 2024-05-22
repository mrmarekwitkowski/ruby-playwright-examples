# frozen_string_literal: true

RSpec.describe 'Example tests' do
  context 'Playwright locator strategies' do
    before(:example) do
      @page.goto('https://playwright.dev/')
    end

    it 'passes using LocatorAssertions' do
      @page.get_by_role('link', name: 'Get started').click
      expect(@page.get_by_role('heading', name: 'Installation')).to be_visible
    end

    it 'passes using "locator.wait_for" method' do
      @page.get_by_role('link', name: 'Get started').click
      locator = @page.get_by_role('heading', name: 'Installation')
      locator.wait_for(timeout: 1_000)
      expect(locator.visible?).to be true
    end

    it 'fails when not using LocatorAssertions', fail: true do
      @page.get_by_role('link', name: 'Get started').click
      locator = @page.get_by_role('heading', name: 'Installation')
      expect(locator.visible?).to be true
    end
  end
end
