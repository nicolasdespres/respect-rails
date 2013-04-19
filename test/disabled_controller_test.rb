require 'test_helper'

class DisabledControllerTest < ActionController::TestCase

  def test_basic_good_request
    get :basic, format: 'json', param1: 42
    assert_response :success
    assert !response.respond_to?(:has_schema?)
  end

  def test_basic_wrong_request_dont_raise
    get :basic, format: 'json', param1: 54
    assert_response :success
    assert !response.respond_to?(:has_schema?)
  end
end
