require "test_helper"

class ResponseDefTest < ActiveSupport::TestCase
  test "can use kernel method" do
    Respect::Rails::ResponseDef.eval do
      p
    end
  end
end
