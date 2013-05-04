class CaughtExceptionController < ApplicationController
  around_filter :validate_schemas
  rescue_from_request_validation_error

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
