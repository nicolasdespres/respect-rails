module Respect
  module Rails
    module ApplicationHelper

      def highlight_json_schema(json_schema)
        Respect::JsonSchemaHTMLFormatter.new(json_schema).dump.html_safe
      end

    end
  end
end
