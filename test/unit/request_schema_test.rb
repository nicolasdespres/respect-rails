require "test_helper"

class RequestSchemaTest < Test::Unit::TestCase
  def setup
    @rs = Respect::Rails::RequestSchema.new("ctrl", "action")
  end

  def test_default_path_parameters
    assert_equal "ctrl", @rs.default_path_parameters["controller"].options[:equal_to]
    assert_equal false, @rs.default_path_parameters["controller"].doc
    assert_equal "action", @rs.default_path_parameters["action"].options[:equal_to]
    assert_equal false, @rs.default_path_parameters["action"].doc
  end

  def test_path_parameters_are_merged_with_default
    params = Respect::HashSchema.new
    result = Respect::HashSchema.new
    @rs.default_path_parameters.stubs(:merge).with(params).returns(result).once
    assert_not_equal result.object_id, @rs.path_parameters.object_id
    assert_equal result.object_id, @rs.public_send(:path_parameters=, params).object_id
    assert_equal result.object_id, @rs.path_parameters.object_id
  end

  def test_validate_all_parameters
    Respect::Rails::Engine.stubs(:disable_request_headers_validation).returns(false)
    request = mock()
    headers = {}
    request.stubs(:headers).with().returns(headers).at_least_once
    @rs.headers.stubs(:validate).with(headers).once
    params = {}
    request.stubs(:params).with().returns(params).at_least_once
    @rs.path_parameters.stubs(:validate).with(params).once
    @rs.path_parameters.stubs(:sanitized_object).returns(params).once
    @rs.query_parameters.stubs(:validate).with(params).once
    @rs.query_parameters.stubs(:sanitized_object).returns(params).once
    @rs.body_parameters.stubs(:validate).with(params).once
    @rs.body_parameters.stubs(:sanitized_object).returns(params).once
    assert_equal true, @rs.validate(request)
  end

  def test_validate_raise_request_validation_error_on_path_params_validation_error
    Respect::Rails::Engine.stubs(:disable_request_headers_validation).returns(false)
    request = mock()
    headers = {}
    request.stubs(:headers).with().returns(headers).at_least_once
    params = {}
    request.stubs(:params).with().returns(params).at_least_once
    @rs.path_parameters.stubs(:validate).with(params).raises(Respect::ValidationError.new("error message")).once
    @rs.query_parameters.stubs(:validate).with(params)
    @rs.body_parameters.stubs(:validate).with(params)
    begin
      @rs.validate(request)
      assert false, "nothing raised"
    rescue Respect::Rails::RequestValidationError => e
      assert e.error.is_a?(Respect::ValidationError)
      assert_equal "error message; in path", e.message
      assert e.part.path?
      assert_equal params, e.object
    end
  end

  def test_validate_raise_request_validation_error_on_query_params_validation_error
    Respect::Rails::Engine.stubs(:disable_request_headers_validation).returns(false)
    request = mock()
    headers = {}
    request.stubs(:headers).with().returns(headers).at_least_once
    params = {}
    request.stubs(:params).with().returns(params).at_least_once
    @rs.path_parameters.stubs(:validate).with(params)
    @rs.query_parameters.stubs(:validate).with(params).raises(Respect::ValidationError.new("error message")).once
    @rs.body_parameters.stubs(:validate).with(params)
    begin
      @rs.validate(request)
      assert false, "nothing raised"
    rescue Respect::Rails::RequestValidationError => e
      assert e.error.is_a?(Respect::ValidationError)
      assert_equal "error message; in query", e.message
      assert e.part.query?
      assert_equal params, e.object
    end
  end

  def test_validate_raise_request_validation_error_on_body_params_validation_error
    Respect::Rails::Engine.stubs(:disable_request_headers_validation).returns(false)
    request = mock()
    headers = {}
    request.stubs(:headers).with().returns(headers).at_least_once
    params = {}
    request.stubs(:params).with().returns(params).at_least_once
    @rs.path_parameters.stubs(:validate).with(params)
    @rs.query_parameters.stubs(:validate).with(params)
    @rs.body_parameters.stubs(:validate).with(params).raises(Respect::ValidationError.new("error message")).once
    begin
      @rs.validate(request)
      assert false, "nothing raised"
    rescue Respect::Rails::RequestValidationError => e
      assert e.error.is_a?(Respect::ValidationError)
      assert_equal "error message; in body", e.message
      assert e.part.body?
      assert_equal params, e.object
    end
  end

  def test_validate_raise_request_validation_error_on_headers_validation_error
    Respect::Rails::Engine.stubs(:disable_request_headers_validation).returns(false)
    request = mock()
    headers = {}
    request.stubs(:headers).with().returns(headers).at_least_once
    @rs.headers.stubs(:validate).with(headers).raises(Respect::ValidationError.new("error message")).once
    simplified_headers = {}
    @rs.stubs(:simplify_headers).with(headers).returns(simplified_headers).once
    params = {}
    request.stubs(:params).with().returns(params)
    @rs.path_parameters.stubs(:validate).with(params)
    @rs.query_parameters.stubs(:validate).with(params)
    @rs.body_parameters.stubs(:validate).with(params)
    begin
      @rs.validate(request)
      assert false, "nothing raised"
    rescue Respect::Rails::RequestValidationError => e
      assert e.error.is_a?(Respect::ValidationError)
      assert_equal "error message; in headers", e.message
      assert e.part.headers?
      assert_equal simplified_headers.object_id, e.object.object_id
    end
  end

  def test_validate_query_returns_true_when_no_error
    request = mock()
    @rs.stubs(:validate).with(request).returns(nil)
    assert_equal true, @rs.validate?(request)
  end

  def test_validate_query_returns_false_on_error_and_store_last_error
    doc = {}
    error = Respect::Rails::RequestValidationError.new(Respect::ValidationError.new("message"), :path, {})
    @rs.stubs(:validate).with(doc).raises(error).once
    assert_equal false, @rs.validate?(doc)
    assert_equal error, @rs.last_error
  end

  def test_validate_shebang_returns_true_on_success_and_sanitize
    request = mock()
    @rs.stubs(:validate?).with(request).returns(true).once
    @rs.stubs(:sanitize!).with(request).once
    assert_equal true, @rs.validate!(request)
  end

  def test_validate_shebang_returns_false_on_failure
    request = mock()
    @rs.stubs(:validate?).with(request).returns(false).once
    assert_equal false, @rs.validate!(request)
  end

  def test_sanitize_all_params
    request = mock()
    params = mock()
    request.stubs(:params).with().returns(params).at_least_once
    @rs.path_parameters.stubs(:sanitize_object!).with(params).once
    @rs.query_parameters.stubs(:sanitize_object!).with(params).once
    @rs.body_parameters.stubs(:sanitize_object!).with(params).once
    @rs.sanitize!(request)
  end
end
