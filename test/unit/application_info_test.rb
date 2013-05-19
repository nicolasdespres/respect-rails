require "test_helper"

class ApplicationInfoTest < ActiveSupport::TestCase
  def setup
    @app = Respect::Rails::ApplicationInfo.new
  end

  def test_name
    assert_equal("Dummy", @app.name)
  end
end
