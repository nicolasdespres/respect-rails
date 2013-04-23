require "test_helper"

class RoutesSetTest < ActiveSupport::TestCase

  def setup
    @routes = Respect::Rails::RoutesSet.new
  end

  def test_engine_route_are_prefixed
    assert(@routes.any?{|r| r.path =~ %r{^/rest_spec/doc} })
  end

  def test_app_name
    assert(Respect::Rails.application_name == @routes.app_name)
  end

  def test_app_routes_are_stored_in_engine_named_after_app
    assert(@routes.engines.has_key?(@routes.app_name))
    assert(@routes.routes == @routes.engines[@routes.app_name])
  end

  def test_engine_names
    engine_names = @routes.engines.keys.sort
    assert_equal 2, engine_names.size
    assert_equal "Dummy", engine_names.first
    assert_equal "Respect", engine_names.second
  end

  def test_each_engine_yield_sorted_key
    expected = @routes.engines.keys.sort
    engine_names = []
    @routes.each_engine{|name, routes| engine_names << name }
    assert_equal expected, engine_names
  end

end
