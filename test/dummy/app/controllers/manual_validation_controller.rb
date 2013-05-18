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
end
