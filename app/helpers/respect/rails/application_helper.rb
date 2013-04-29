module Respect
  module Rails
    module ApplicationHelper
      def highlight_json_schema(json_schema)
        content_tag(:pre) do
          content_tag(:code) do
            JSON.pretty_generate(json_schema).html_safe
          end
        end
      end
    end
  end
end
