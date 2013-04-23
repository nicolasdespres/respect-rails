require "test_helper"

class RoutesSetTest < ActiveSupport::TestCase

  def test_engine_route_are_prefixed
    assert(Respect::Rails::RoutesSet.new.any?{|r| r.path =~ %r{^/rest_spec/doc} })
  end

end
