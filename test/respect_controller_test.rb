require 'test_helper'

class RespectControllerTest < ActionController::TestCase
  def test_should_get_index
    get :index, use_route: :respect
    assert_response :success
  end
end
