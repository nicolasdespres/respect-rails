require "test_helper"

class InfoTest < ActiveSupport::TestCase

  def setup
    @info = Respect::Rails::Info.new
  end

  def test_engine_route_are_prefixed
    assert(@info.routes.any?{|r| r.path =~ %r{^/rest_spec/doc} })
  end

  def test_app_name
    assert_equal("dummy", @info.app.name)
  end

  def test_app_is_stored_in_engines
    assert(@info.engines.has_value?(@info.app))
    assert(@info.routes == @info.app.routes)
  end

end
