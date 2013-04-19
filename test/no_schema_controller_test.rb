require 'test_helper'

class NoSchemaControllerTest < ActionController::TestCase

  def test_no_schema_always_validate
    # We send invalid value but it validates anyway because their is no schema.
    get :basic, format: 'json', param1: 51
    assert_response :success
    assert !response.has_schema?
  end

end
