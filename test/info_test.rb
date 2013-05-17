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
    assert_equal 6, @info.toc.size
  end

  def test_route_not_collected_if_no_schema
    # FIXME(Nicolas Despres): Use a moch instead of relying on the dummy app which may change too often.
    assert(@info.routes.none?{|r| r.path =~ %r{/automatic_validation/no_schema_at_all} })
    assert(@info.routes.any?{|r| r.path =~ %r{/automatic_validation/no_request_schema} })
    assert(@info.routes.none?{|r| r.path =~ %r{/manual_validation/no_schema} })
    assert(@info.routes.none?{|r| r.path =~ %r{/no_schema/basic} })
  end

  def test_action_not_in_toc_if_no_schemas
    # FIXME(Nicolas Despres): Use a moch instead of relying on the dummy app which may change too often.
    assert(!@info.toc["automatic_validation"].key?("no_schema_at_all"))
    assert(@info.toc["automatic_validation"].key?("no_request_schema"))
    assert(!@info.toc["manual_validation"].key?("no_schema"))
    assert(!@info.toc.key?("no_schema"))
  end

  def test_action_with_only_documentation_are_in_toc
    assert(@info.toc["automatic_validation"].key?("only_documentation"))
  end
end
