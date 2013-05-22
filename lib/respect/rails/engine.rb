require 'respect'

require 'respect/rails/headers_helper'
require 'respect/rails/request_helper'
require 'respect/rails/response_helper'
require 'respect/rails/controller_helper'

module Respect
  module Rails
    class Engine < ::Rails::Engine
      isolate_namespace Respect::Rails
      engine_name 'respect'

      # Whether responses are validated by the +validate_schemas+ around filter.
      # By default this is +true+ in development and test environment and +false+ otherwise.
      cattr_accessor :validate_response
      self.validate_response = (::Rails.env.development? || ::Rails.env.test?)

      # Whether response validation error are caught. The exception will be rendered in JSON
      # and the HTTP status will be set to 500.
      # By default this is +true+ in development mode only.
      cattr_accessor :catch_response_validation_error
      self.catch_response_validation_error = ::Rails.env.development?

      # Whether to validate request headers.
      # This option is available because Rails 3 does not support headers well in test mode.
      # It is +false+ by default in test mode to let you do non-headers related functional
      # test anyway.
      # See: https://github.com/rails/rails/issues/6513
      cattr_accessor :disable_request_headers_validation
      self.disable_request_headers_validation = ::Rails.env.test?

      # Set the application name use in the documentation. By default it is the same
      # as your application class.
      cattr_writer :doc_app_name
      def self.doc_app_name
        @@doc_app_name ||= ::Rails.application.class.parent_name
      end

      # Default way to setup Respect for Rails.
      def self.setup(&block)
        block.call(self)
      end

      # See {Engine.app_documentation}.
      cattr_writer :app_documentation

      self.app_documentation = ""

      # Set the documentation of your application. The title would be the first line
      # if followed by an empty line and the description would be the rest.
      # If +text+ is +nil+ the current documentation is returned.
      def self.app_documentation(text = nil)
        if text
          @@app_documentation = text
        else
          @@app_documentation
        end
      end

      # Include all +helper_modules+ in the DSL definition classes, so that you can use its
      # methods for defining schema.
      def self.helpers(*helper_modules)
        helper_modules.each{|m| Respect.extend_dsl_with(m) }
      end
    end # class Engine
  end # module Rails
end # module Respect
