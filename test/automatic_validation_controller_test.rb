require 'test_helper'

class AutomaticValidationControllerTest < ActionController::TestCase

  def test_basic_get_works
    get :basic_get, format: 'json', param1: 42
    assert_response :success
    assert response.has_schema?
  end

  def test_basic_request_error_raises_exception
    assert_raise(Respect::Rails::RequestValidationError) do
      get :basic_get, format: 'json', param1: 54
    end
  end

  def test_no_schema_at_all_always_validate_request_and_response
    get :no_schema_at_all, format: 'json', param1: "whatever"
    assert_response :success
    assert !response.has_schema?
  end

  def test_no_request_schema_still_validate_good_response
    get :no_request_schema, format: 'json', returned_id: 42
    assert_response :success
    assert response.has_schema?
    assert response.validate_schema?
  end

  def test_no_request_schema_still_invalidate_wrong_response
    assert_raises(Respect::Rails::ResponseValidationError) do
      get :no_request_schema, format: 'json', returned_id: 6666666
    end
  end

  def test_response_schema_from_file_for_created_status
    get :response_schema_from_file, format: 'json', returned_id: 42
    assert_response :created
    assert response.has_schema?
    assert response.validate_schema?
  end

  def test_response_schema_from_file_for_created_status_with_wrong_response
    assert_raise(Respect::Rails::ResponseValidationError) do
      get :response_schema_from_file, format: 'json', returned_id: 51
    end
  end

  def test_response_schema_from_file_for_unprocessable_entity_status
    get :response_schema_from_file, format: 'json', failure: true
    assert_response :unprocessable_entity
    assert response.has_schema?
    assert response.validate_schema?
  end

  def test_response_schema_from_file_for_unknown_status
    assert_nothing_raised do
      # We let the users define whatever non-sens status code they want.
      get :response_schema_from_file_unknown_status, format: 'json', returned_id: 42
    end
  end

  def test_route_constraints_validates_before_validator
    # FIXME(Nicolas Despres): This test does not work because route's constraints do not
    # seem to be applied in test mode. The test work manually from the web browser. Here we
    # get a ValidationError instead of a RoutingError.
    # assert_raise(ActionController::RoutingError) do
    #   get :route_constraints, format: 'json', param1: "51"
    # end
  end

  def test_composite_custom_types
    # assert_nothing_raised do
      get :composite_custom_types, format: 'json',
          circle: { center: { x: "1.0", y: "2.0" }, radius: "5.5" },
          color: [ 0.0, 0.1, 0.2, 0.3 ]
    # end
    assert_response :success
  end

  def test_engine_uri_helpers
    get :dump_uri_helpers, format: 'json'
    assert_response :success

    json = ActiveSupport::JSON.decode(@response.body)

    assert_equal "/rest_spec", json['respect_path']
    assert_equal "/rest_spec/doc", json['respect']['doc_path']
    assert_equal "/rest_spec/", json['respect']['root_path']
  end

  def test_default_response_schema_in_file_found_for_ok
    get :default_response_schema_in_file, format: 'json', failure: false
    assert_response :ok
    assert response.has_schema?
    assert response.validate_schema?
  end

  def test_default_response_schema_in_file_not_found_for_not_ok
    get :default_response_schema_in_file, format: 'json', failure: true
    assert_response :unprocessable_entity
    assert !response.has_schema?
  end

  def test_request_validation_error_have_context
    begin
      get :request_contextual_error, format: 'json', o1: { o2: { i: 54 } }
      assert false
    rescue Respect::Rails::RequestValidationError => e
      assert(e.context.first == e.message)
      assert_equal(4, e.context.size)
    end
  end

  def test_response_validation_error_have_context
    begin
      get :response_contextual_error, format: 'json'
      assert false
    rescue Respect::Rails::ResponseValidationError => e
      assert(e.context.first == e.message)
      assert_equal(4, e.context.size)
    end
  end

  def test_format_is_not_required
    get :request_format
    assert_response :success
  end

  def test_format_html_validate
    get :request_format, format: "html"
    assert_response :success
  end

  def test_format_json_validate
    get :request_format, format: "json"
    assert_response :success
  end

  def test_format_pdf_validate
    get :request_format, format: "pdf"
    assert_response :success
  end

end
