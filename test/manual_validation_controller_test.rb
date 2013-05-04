require 'test_helper'

class ManualValidationControllerTest < ActionController::TestCase

  def test_raise_custom_error_with_manual_request_validation
    assert_raise(RuntimeError) do
      get :raise_custom_error, format: 'json', param1: 54
    end
  end

  def test_raise_custom_error_with_manual_request_validation_without_rescue
    assert_raise(RuntimeError) do
      get :raise_custom_error_without_rescue, format: 'json', param1: 54
    end
  end

  def test_no_schema_always_validate
    get :no_schema, format: 'json', param1: 1664
    assert_response :success
    assert !response.has_schema?
    assert_response_validate_schema
  end

end
