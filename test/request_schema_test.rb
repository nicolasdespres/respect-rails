require "test_helper"

class RequestSchemaTest < Test::Unit::TestCase
  def setup
    @rs = Respect::Rails::RequestSchema.new("ctrl", "action")
  end

  def test_default_url_params
    assert_equal "ctrl", @rs.default_url_params["controller"].options[:equal_to]
    assert_equal false, @rs.default_url_params["controller"].doc
    assert_equal "action", @rs.default_url_params["action"].options[:equal_to]
    assert_equal false, @rs.default_url_params["action"].doc
  end

  def test_url_params_are_merged_with_default
    params = Respect::ObjectSchema.new
    result = Respect::ObjectSchema.new
    @rs.default_url_params.stubs(:merge).with(params).returns(result).once
    assert_not_equal result.object_id, @rs.url_params.object_id
    assert_equal result.object_id, @rs.public_send(:url_params=, params).object_id
    assert_equal result.object_id, @rs.url_params.object_id
  end

  def test_validate_both_body_and_url_params
    doc = {}
    schema = Respect::ObjectSchema.new
    result = Object.new
    schema.stubs(:validate).with(doc).returns(result).once
    @rs.body_params.stubs(:merge).with(@rs.url_params).returns(schema).once
    assert_equal result.object_id, @rs.validate(doc).object_id
    assert_equal schema.object_id, @rs.last_params.object_id
  end

  def test_validate_raise_request_validation_error_on_validation_error
    doc = {}
    Respect::Schema.any_instance.stubs(:validate).with(doc).raises(Respect::ValidationError)
    assert_raises(Respect::Rails::RequestValidationError) do
      @rs.validate(doc)
    end
  end

  def test_validate_query_returns_true_when_no_error
    doc = {}
    @rs.stubs(:validate).with(doc).returns(nil)
    assert_equal true, @rs.validate?(doc)
  end

  def test_validate_query_returns_false_on_error_and_store_last_error
    doc = {}
    error = Respect::Rails::RequestValidationError.new(Respect::ValidationError.new("message"))
    @rs.stubs(:validate).with(doc).raises(error).once
    assert_equal false, @rs.validate?(doc)
    assert_equal error, @rs.last_error
  end

  def test_validate_shebang_returns_true_on_success_and_sanitize
    doc = {}
    @rs.stubs(:validate?).with(doc).returns(true).once
    schema = Respect::ObjectSchema.new
    @rs.stubs(:last_params).returns(schema)
    sanitized_doc = {}
    schema.stubs(:sanitized_doc).returns(sanitized_doc).once
    schema.stubs(:sanitize_doc).with(doc, sanitized_doc).once
    assert_equal true, @rs.validate!(doc)
  end

  def test_validate_shebang_returns_false_on_failure
    doc = {}
    @rs.stubs(:validate?).with(doc).returns(false).once
    assert_equal false, @rs.validate!(doc)
  end

end
