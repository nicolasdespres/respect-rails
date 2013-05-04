require 'test_helper'

class CaughtExceptionControllerTest < ActionController::TestCase

  def test_request_validation_error_not_raised_when_rescued
    get :request_validator, id: "error_value"
    assert_response :internal_server_error
    assert_select "title", { count: 1, text: "Validation error" }
    assert_select "h1", { count: 1, text: /validation error/i }
    assert_select "h1", /in CaughtExceptionController#request_validator/
    assert_select "pre", /\bin object property\b/
    assert_select "pre", /\bid\b/
    assert_select "pre", /\bmalformed integer value\b/
    assert_select "pre", /\berror_value\b/
  end

end
