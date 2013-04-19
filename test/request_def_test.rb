require "test_helper"

class RequestDefTest < ActiveSupport::TestCase
  test "can use kernel method" do
    Respect::Rails::RequestDef.eval("controller", "action") do
      p
    end
  end
end
