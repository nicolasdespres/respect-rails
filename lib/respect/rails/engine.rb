require 'respect'

require 'respect/rails/helper'

module Respect
  module Rails
    class Engine < ::Rails::Engine
      isolate_namespace Respect::Rails
      engine_name 'respect'

      # Whether response are validated by the +validate_schemas+ around filter.
      # By default this is +true+ in development and test environment and +false+ otherwise.
      mattr_accessor :validate_response
      self.validate_response = (::Rails.env.development? || ::Rails.env.test?)

    end # class Engine

  end # module Rails
end # module Respect
