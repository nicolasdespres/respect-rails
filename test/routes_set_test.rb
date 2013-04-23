require "test_helper"

class RoutesSetTest < ActiveSupport::TestCase

  def test_engine_route_are_prefixed
    assert(Respect::Rails::RoutesSet.new.any?{|r| r.path =~ %r{^/rest_spec/doc} })
  end

  def test_app_name
    routes_set = Respect::Rails::RoutesSet.new
    assert(Respect::Rails.application_name == routes_set.app_name)
  end

  def test_app_routes_are_stored_in_engine_named_after_app
    routes_set = Respect::Rails::RoutesSet.new
    assert(routes_set.engines.has_key?(routes_set.app_name))
    assert(routes_set.routes == routes_set.engines[routes_set.app_name])
  end

end
