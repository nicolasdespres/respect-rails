require 'test_helper'

class CaughtExceptionControllerTest < ActionController::TestCase

  def test_request_validation_error_rendered_when_rescued_in_html_format
    get :request_validator, format: 'html', id: "error_value"
    assert_response :internal_server_error
    assert_select "title", { count: 1, text: "Request validation error caught" }
    assert_select "h1", { count: 1, text: /validation error/i }
    assert_select "h1", /in CaughtExceptionController#request_validator/
    assert_select "pre", /\bin hash property\b/
    assert_select "pre", /\bid\b/
    assert_select "pre", /\bmalformed integer value\b/
    assert_select "pre", /\berror_value\b/
    assert_select "p", /\bInvalid query parameters\b/
    assert_select "p", /\bProcessed object\b/ do
      assert_select "div[class=json_highlight]", true
    end
  end

  def test_request_validation_error_rendered_when_rescued_in_json_format
    get :request_validator, format: 'json', id: "error_value"
    assert_response :internal_server_error
    json = ActiveSupport::JSON.decode(response.body)
    assert json.key?("error")
    assert_equal("Respect::Rails::RequestValidationError", json["error"]["class"])
    assert_match(/\bmalformed integer value\b/, json["error"]["message"])
    assert_match(/\berror_value\b/, json["error"]["message"])
    assert_kind_of(Array, json["error"]["context"])
    assert_equal("query", json["error"]["part"])
    assert_equal({"id"=>"error_value",
        "format"=>"json",
        "controller"=>"caught_exception",
        "action"=>"request_validator"}, json["error"]["object"])
  end

  def test_response_validation_error_not_raised_when_caught
    Respect::Rails::Engine.stubs(:catch_response_validation_error).returns(true)
    get :response_validator, format: 'json', id: "error_value"
    assert_response :internal_server_error
    assert_equal(response.body, response.last_validation_error.to_json)
  end

  def test_no_response_validation_for_html_format
    get :response_validator, format: 'html', id: "error_value"
    assert_response :success
    assert_select "body", "No response validation for HTML format."
  end

end
