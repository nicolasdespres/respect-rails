require "test_helper"

class InfoTest < ActiveSupport::TestCase

  def setup
    @info = Respect::Rails::Info.new
  end

  def test_engine_route_are_prefixed
    assert(@info.routes.any?{|r| r.path =~ %r{^/rest_spec/doc} })
  end

  def test_app_name
    assert(Respect::Rails.application_name == @info.app.name)
  end

  def test_app_is_stored_in_engines
    assert(@info.engines.include?(@info.app))
    assert(@info.routes == @info.app.routes)
  end

  def test_engines_are_sorted_by_names
    assert_equal 2, @info.engines.size
    assert_equal "Dummy", @info.engines.first.name
    assert_equal "Respect", @info.engines.second.name
  end

end
