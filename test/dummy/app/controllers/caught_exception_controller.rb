class CaughtExceptionController < ApplicationController
  around_filter :validate_schemas!
  rescue_from_request_validation_error

  def_action_schema :request_validator do |s|
    s.request do |r|
      r.query_parameters do |s|
        s.integer :id, equal_to: 42
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
