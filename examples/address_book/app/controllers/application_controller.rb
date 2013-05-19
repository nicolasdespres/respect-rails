class ApplicationController < ActionController::Base
  protect_from_forgery

  # Install the schema validator. Requests and responses would be validated.
  # Responses are only validated in test and development mode.
  around_filter :validate_schemas!

  # Un-comment this line if you want the request params to be sanitized *in-place*.
  # A sanitized version is always available via +request.sane_params+.
  # before_filter :sanitize_params!

  # Prettier request validation error report.
  rescue_from_request_validation_error if Rails.env.development?
end
