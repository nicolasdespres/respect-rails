require 'respect/rails/engine'

module Respect
  module Rails
    extend ActiveSupport::Autoload

    autoload :ActionSchema
    autoload :ResponseSchemaSet
    autoload :RequestSchema
    autoload :ResponseSchema
    autoload :RequestDef
    autoload :ResponseDef
    autoload :Info
    autoload :ApplicationInfo
    autoload :EngineInfo
    autoload :RouteInfo

    class << self
      def load_schema(controller_name, action_name)
        ActionSchema.from_controller(controller_name, action_name)
      end

      # Install all user-defined macros in +app/helpers/respect+ and extend the DSL with
      # them.
      def install_macros
        Pathname.glob("#{::Rails.root}/app/helpers/#{self.name.underscore}/*_macros.rb") do |path|
          require path.to_s
          module_name = path.sub_ext('').sub(%r{^#{::Rails.root}/app/helpers/}, '').to_s
          self.extend_dsl_with(module_name.camelize.constantize)
        end
      end

      # Return the name of the application where Respect's engine is mounted.
      def application_name
        ::Rails.application.class.parent_name
      end
    end # class << self
  end # module Rails
end # module Respect
