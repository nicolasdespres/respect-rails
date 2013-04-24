require "test_helper"

class InfoTest < ActiveSupport::TestCase

  def setup
    @info = Respect::Rails::Info.new
  end

  def test_engine_route_are_prefixed
    assert(@info.routes.any?{|r| r.path =~ %r{^/rest_spec/doc} })
  end

  def test_app_is_stored_in_engines
    assert(@info.engines.has_value?(@info.app))
    assert(@info.routes == @info.app.routes)
  end

  def test_toc
    # FIXME(Nicolas Despres): Use a moch instead of relying on the dummy app which may change too often.
    assert_equal 4, @info.toc.size
  end
end
