require 'respect'

require 'respect/rails/helper'

module Respect
  module Rails
    class Engine < ::Rails::Engine
      isolate_namespace Respect::Rails
      engine_name 'respect'

      # Whether responses are validated by the +validate_schemas+ around filter.
      # By default this is +true+ in development and test environment and +false+ otherwise.
      mattr_accessor :validate_response
      self.validate_response = (::Rails.env.development? || ::Rails.env.test?)

      # Whether response validation error are caught. The exception will be rendered in JSON
      # and the HTTP status will be set to 500.
      # By default this is +true+ in development mode only.
      mattr_accessor :catch_response_validation_error
      self.catch_response_validation_error = ::Rails.env.development?

    end # class Engine

  end # module Rails
end # module Respect
