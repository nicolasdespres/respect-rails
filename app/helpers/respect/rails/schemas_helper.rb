module Respect
  module Rails
    module SchemasHelper

      def highlight_json_schema(json_schema)
        Respect::JSONSchemaHTMLFormatter.new(json_schema).dump.html_safe
      end

    end
  end
end
