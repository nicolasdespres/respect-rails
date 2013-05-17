class ApplicationController < ActionController::Base
  protect_from_forgery

  around_filter :validate_schemas

  rescue_from_request_validation_error if Rails.env.development?
end
