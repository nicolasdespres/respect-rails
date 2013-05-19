module Respect
  module Rails
    module SchemasHelper

      def highlight_json_schema(json_schema)
        Respect::JSONSchemaHTMLFormatter.new(json_schema).dump.html_safe
      end

      def describe_option(name, value)
        result = describe_option_internal(name, value)
        result.html_safe if result
      end

      private

      def describe_option_internal(name, value)
        case name
        when :doc, :required
          nil
        when :default
          if value.nil?
            nil
          else
            "default to #{value.inspect}"
          end
        when :equal_to
          "Must be equal to #{value.inspect}"
        when :allow_nil
          if value
            "May be null"
          else
            nil
          end
        else
          "#{name}: #{value.inspect}"
        end
      end
    end
  end
end
