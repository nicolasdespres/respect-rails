require "test_helper"

class HelperTest < Test::Unit::TestCase
  def test_successful_request_validation
    request = Object.new
    request.extend(Respect::Rails::Helper::Request)
    params = {}
    request.stubs(:params).with().returns(params)
    schema = mock()
    schema.stubs(:validate!).with(params).returns(true).once
    request.stubs(:request_schema).with().returns(schema)
    Benchmark.stubs(:realtime).with().yields().returns(1.2345) # 1234.5 seconds.
    ::Rails.logger.stubs(:info).with("  Request validation: success (1234.5ms)").once
    assert_nothing_raised do
      request.validate_schema
    end
  end

  def test_failed_request_validation
    request = Object.new
    request.extend(Respect::Rails::Helper::Request)
    params = {}
    request.stubs(:params).with().returns(params)
    schema = mock()
    schema.stubs(:validate!).with(params).returns(false).once
    error = RuntimeError.new("test error")
    error.stubs(:context).with().returns(["foo", "bar"])
    schema.stubs(:last_error).with().returns(error)
    request.stubs(:request_schema).with().returns(schema)
    Benchmark.stubs(:realtime).with().yields().returns(1.2345) # 1234.5 seconds.
    ::Rails.logger.stubs(:info).with("  Request validation: failure (1234.5ms)").once
    ::Rails.logger.stubs(:info).with("    foo").once
    ::Rails.logger.stubs(:info).with("    bar").once
    begin
      request.validate_schema
      assert false, "nothing raised"
    rescue RuntimeError => e
      assert_equal error, e
    end
  end

  def test_none_request_validation
    request = Object.new
    request.extend(Respect::Rails::Helper::Request)
    request.stubs(:params).with().never
    schema = mock()
    schema.stubs(:validate!).never
    request.stubs(:request_schema).with().returns(nil)
    Benchmark.stubs(:realtime).with().yields().returns(1.2345) # 1234.5 seconds.
    ::Rails.logger.stubs(:info).with("  Request validation: none (1234.5ms)").once
    assert_nothing_raised do
      request.validate_schema
    end
  end

  def test_request_validation_schema_query_on_success
    request = Object.new
    request.extend(Respect::Rails::Helper::Request)
    request.stubs(:validate_schema).returns(true)
    assert_equal(true, request.validate_schema?)
  end

  def test_request_validation_schema_query_on_failure
    request = Object.new
    request.extend(Respect::Rails::Helper::Request)
    request.stubs(:validate_schema).raises(Respect::Rails::RequestValidationError.new(mock(), :path))
    assert_equal(false, request.validate_schema?)
  end

  def test_successful_response_validation
    response = Object.new
    response.extend(Respect::Rails::Helper::Response)
    body = ""
    schema = mock()
    response.stubs(:schema).with().returns(schema)
    response.stubs(:body).with().returns(body)
    response.stubs(:content_type).with().returns(Mime::JSON)
    decoded_body = {}
    ActiveSupport::JSON.stubs(:decode).with(body).returns(decoded_body).once
    schema.stubs(:validate?).with(decoded_body).returns(true).once
    Benchmark.stubs(:realtime).with().yields().returns(1.2345) # 1234.5 seconds.
    Rails.logger.stubs(:info).with("  Response validation: success (1234.5ms)").once
    assert_nothing_raised do
      response.validate_schema
    end
  end

  def test_failed_response_validation
    response = Object.new
    response.extend(Respect::Rails::Helper::Response)
    body = ""
    schema = mock()
    response.stubs(:schema).with().returns(schema)
    response.stubs(:body).with().returns(body)
    response.stubs(:content_type).with().returns(Mime::JSON)
    decoded_body = {}
    ActiveSupport::JSON.stubs(:decode).with(body).returns(decoded_body).once
    schema.stubs(:validate?).with(decoded_body).returns(false).once
    error = RuntimeError.new("test error")
    error.stubs(:context).with().returns(["foo", "bar"])
    schema.stubs(:last_error).with().returns(error)
    Benchmark.stubs(:realtime).with().yields().returns(1.2345) # 1234.5 seconds.
    Rails.logger.stubs(:info).with("  Response validation: failure (1234.5ms)").once
    Rails.logger.stubs(:info).with("    foo").once
    Rails.logger.stubs(:info).with("    bar").once
    begin
      response.validate_schema
      assert false, "nothing raised"
    rescue RuntimeError => e
      assert_equal error, e
    end
  end

  def test_none_response_validation
    response = Object.new
    response.extend(Respect::Rails::Helper::Response)
    body = ""
    schema = mock()
    response.stubs(:schema).with().returns(nil)
    response.stubs(:body).with().never
    response.stubs(:content_type).with().never
    schema.stubs(:validate?).never
    Benchmark.stubs(:realtime).with().yields().returns(1.2345) # 1234.5 seconds.
    ::Rails.logger.stubs(:info).with("  Response validation: none (1234.5ms)").once
    assert_nothing_raised do
      response.validate_schema
    end
  end

  def test_response_validation_schema_query_on_success
    response = Object.new
    response.extend(Respect::Rails::Helper::Response)
    response.stubs(:validate_schema).returns(true)
    assert_equal(true, response.validate_schema?)
  end

  def test_response_validation_schema_query_on_failure
    response = Object.new
    response.extend(Respect::Rails::Helper::Response)
    response.stubs(:validate_schema).raises(Respect::Rails::ResponseValidationError.new(mock()))
    assert_equal(false, response.validate_schema?)
  end
end
