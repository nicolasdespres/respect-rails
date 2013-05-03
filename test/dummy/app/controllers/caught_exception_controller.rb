class CaughtExceptionController < ApplicationController
  around_filter :validate_schemas
  rescue_from Respect::ValidationError do |exception|
    @error = exception
    render template: "respect/rails/validation_exception", layout: false, status: :internal_server_error
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
end
