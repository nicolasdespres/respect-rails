# An example of manual validation without using any filter.
class ManualValidationController < ApplicationController
  # GET /manual_validation/raise_custom_error.json
  def raise_custom_error
    begin
      request.validate_schema
    rescue Respect::Rails::RequestValidationError
      raise "invalid request schema (raised manually for testing)"
    end
  end

  # GET /manual_validation/raise_custom_error.json
  def raise_custom_error_without_rescue
    unless request.validate_schema?
      raise "invalid request schema"
    end
  end

  # GET /manual_validation/no_schema.json
  def no_schema
    unless request.validate_schema?
      raise "should never be raised since requests with no schema are always valid"
    end
    respond_to do |format|
      format.json do
        render json: {}
      end
    end
  end

  after_filter :test_response_is_instrumented

  private

  def test_response_is_instrumented
    # We have to explicitly load the response schema since our hook
    # may be called before the gem's hook.
    load_response_schema
    unless response.respond_to? :validate_schema
      raise "response should be instrumented at this point"
    end
  end

end
