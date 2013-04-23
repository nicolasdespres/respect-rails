require "test_helper"

class RailsTest < ActiveSupport::TestCase
  def test_application_name
    assert_equal "Dummy", Respect::Rails.application_name
  end
end
