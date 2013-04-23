require "test_helper"

class RoutesSetTest < ActiveSupport::TestCase

  def setup
    @routes = Respect::Rails::RoutesSet.new
  end

  def test_engine_route_are_prefixed
    assert(@routes.any?{|r| r.path =~ %r{^/rest_spec/doc} })
  end

  def test_app_name
    assert(Respect::Rails.application_name == @routes.app.name)
  end

  def test_app_is_stored_in_engines
    assert(@routes.engines.include?(@routes.app))
    assert(@routes.routes == @routes.app.routes)
  end

  def test_engines_are_sorted_by_names
    assert_equal 2, @routes.engines.size
    assert_equal "Dummy", @routes.engines.first.name
    assert_equal "Respect", @routes.engines.second.name
  end

end
