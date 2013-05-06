require "test_helper"

class RequestDefTest < ActiveSupport::TestCase
  test "can use kernel method" do
    Respect::Rails::RequestDef.eval("controller", "action") do
      p
    end
  end

  test "path params are not merged when called twice" do
    r = Respect::Rails::RequestDef.new("ctrl", "act").eval do |r|
      r.path_parameters do |s|
        s.integer "foo"
      end
      r.path_parameters do |s|
        s.integer "bar"
      end
    end
    assert r.path_parameters.has_property?("bar")
    assert !r.path_parameters.has_property?("foo")
  end
end
