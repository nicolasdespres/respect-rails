module Respect
  module Rails
    module ApplicationHelper
      def highlight_json_schema(json_schema)
        "<pre><code>#{JSON.pretty_generate(json_schema)}</pre></code>".html_safe
      end
    end
  end
end
