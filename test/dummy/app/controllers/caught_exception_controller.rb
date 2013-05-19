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

  def_action_schema :response_validator do |s|
    s.response_for do |status|
      status.ok do |r|
        r.body do |s|
          s.integer :id, equal_to: 42
        end
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

  def_action_schema :headers_check do |s|
    s.request do |r|
      r.headers do |h|
        h["X-Test-Header"] = "good"
      end
    end
  end
  def headers_check
    respond_to do |format|
      format.json do
        render json: {}
      end
    end
  end

end
