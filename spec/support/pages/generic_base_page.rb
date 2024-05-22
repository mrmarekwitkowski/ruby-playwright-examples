# frozen_string_literal: true

class GenericBasePage
  # include RSpec::Expectations
  # include RSpec::Matchers

  attr_reader :page

  def initialize(page)
    @page = page
  end

  def local_storage
    page.wait_for_function('localStorage')
  end
end
