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


end
