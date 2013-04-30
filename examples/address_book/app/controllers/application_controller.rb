class ApplicationController < ActionController::Base
  protect_from_forgery

  around_filter :validate_schemas
end
