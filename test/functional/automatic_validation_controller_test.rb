require 'test_helper'

class AutomaticValidationControllerTest < ActionController::TestCase

  def test_basic_get_works
    get :basic_get, format: 'json', param1: "42"
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
  end

  def test_no_request_schema_still_invalidate_wrong_response
    assert_raises(Respect::Rails::ResponseValidationError) do
      get :no_request_schema, format: 'json', returned_id: 6666666
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

  def test_request_validation_error_have_context
    begin
      get :request_contextual_error, format: 'json', o1: { o2: { i: 54 } }
      assert false, "exception should be raised"
    rescue Respect::Rails::RequestValidationError => e
      assert(e.context.first == e.error.message)
      assert_match e.context.last, /\b#{e.part}\b/
      assert_equal(5, e.context.size)
    end
  end

  def test_response_validation_error_have_context
    begin
      get :response_contextual_error, format: 'json'
      assert false
    rescue Respect::Rails::ResponseValidationError => e
      assert(e.context.first == e.error.message)
      assert_match e.context.last, /\b#{e.part}\b/
      assert_equal(5, e.context.size)
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

  def test_post_valid_request
    post :basic_post, format: 'json', path_param: "42", body_param: "42", response_param: 42
    assert_response :success
  end

  def test_successful_request_headers_check
    set_request_header("test_header", "value")
    get :check_request_headers, format: 'json'
    assert_response :success
  end

  def test_failed_request_headers_check
    set_request_header("test_header", "erroneous_value")
    assert_raises(Respect::Rails::RequestValidationError) do
      get :check_request_headers, format: 'json'
    end
  end

  def test_successful_response_headers_check
    get :check_response_headers, format: 'json', response_header_value: "good"
    assert_response :success
  end

  def test_failed_response_headers_check
    assert_raises(Respect::Rails::ResponseValidationError) do
      get :check_response_headers, format: 'json', response_header_value: "wrong"
    end
  end

  private

  def set_request_header(key, value)
    # FIXME(Nicolas Despres): Find a less hacky way to do it. This should become
    # easier with Rails 4 according to ActionDispatch::Http::Headers new implementation.
    @request.instance_variable_get(:@env)[key] = value
  end
end
