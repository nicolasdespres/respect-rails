require "test_helper"

class ApplicationInfoTest < ActiveSupport::TestCase
  def setup
    @app = Respect::Rails::ApplicationInfo.new
  end

  def test_name
    assert_equal("dummy", @app.name)
  end
end
