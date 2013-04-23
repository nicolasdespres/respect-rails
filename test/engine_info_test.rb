require "test_helper"

class EngineInfoTest < ActiveSupport::TestCase
  def setup
    @engine = Respect::Rails::EngineInfo.new(Respect::Rails::Engine)
  end

  def test_name
    assert_equal("respect", @engine.name)
  end
end
