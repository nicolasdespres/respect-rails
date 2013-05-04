class CaughtExceptionController < ApplicationController
  around_filter :validate_schemas
  rescue_from Respect::Rails::RequestValidationError do |exception|
    respond_to do |format|
      format.html do
        @error = exception
        render template: "respect/rails/request_validation_exception", layout: false, status: :internal_server_error
      end
      format.json do
        render json: exception.to_json, status: :internal_server_error
      end
    end
  end

  def request_validator
    @id = params[:id]
    respond_to do |format|
      format.json do
        result = { id: @id }
        render json: result
      end
    end
  end

  def response_validator
    @id = params[:id]
    respond_to do |format|
      format.html
      format.json do
        result = { id: @id }
        render json: result
      end
    end
  end

end
