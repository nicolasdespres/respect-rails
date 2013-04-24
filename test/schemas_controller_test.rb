require 'test_helper'

class SchemasControllerTest < ActionController::TestCase
  tests Respect::Rails::SchemasController

  def test_should_get_index
    get :index, use_route: :respect
    assert_response :success
    # FIXME(Nicolas Despres): Test view using assert_select once we
    # have restructured the HTML more cleanly.
    # FIXME(Nicolas Despres): Test listing are sorted.
  end
end
