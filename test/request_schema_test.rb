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
    params = Respect::ObjectSchema.new
    result = Respect::ObjectSchema.new
    @rs.default_path_parameters.stubs(:merge).with(params).returns(result).once
    assert_not_equal result.object_id, @rs.path_parameters.object_id
    assert_equal result.object_id, @rs.public_send(:path_parameters=, params).object_id
    assert_equal result.object_id, @rs.path_parameters.object_id
  end

  def test_validate_both_body_and_path_parameters
    request = mock()
    params = {}
    request.stubs(:params).with().returns(params).at_least_once
    @rs.path_parameters.stubs(:validate).with(params).once
    @rs.request_parameters.stubs(:validate).with(params).once
    assert_equal true, @rs.validate(request)
  end

  def test_validate_raise_request_validation_error_on_validation_error
    request = mock()
    params = {}
    request.stubs(:params).with().returns(params).at_least_once
    Respect::Schema.any_instance.stubs(:validate).with(params).raises(Respect::ValidationError)
    assert_raises(Respect::Rails::RequestValidationError) do
      @rs.validate(request)
    end
  end

  def test_validate_query_returns_true_when_no_error
    request = mock()
    @rs.stubs(:validate).with(request).returns(nil)
    assert_equal true, @rs.validate?(request)
  end

  def test_validate_query_returns_false_on_error_and_store_last_error
    doc = {}
    error = Respect::Rails::RequestValidationError.new(Respect::ValidationError.new("message"), :path)
    @rs.stubs(:validate).with(doc).raises(error).once
    assert_equal false, @rs.validate?(doc)
    assert_equal error, @rs.last_error
  end

  def test_validate_shebang_returns_true_on_success_and_sanitize
    request = mock()
    params = {}
    request.stubs(:params).with().returns(params).at_least_once
    @rs.stubs(:validate?).with(request).returns(true).once
    @rs.path_parameters.stubs(:sanitize_doc!).with(params, @rs.path_parameters.sanitized_doc).once
    @rs.request_parameters.stubs(:sanitize_doc!).with(params, @rs.request_parameters.sanitized_doc).once
    assert_equal true, @rs.validate!(request)
  end

  def test_validate_shebang_returns_false_on_failure
    request = mock()
    @rs.stubs(:validate?).with(request).returns(false).once
    assert_equal false, @rs.validate!(request)
  end

end
