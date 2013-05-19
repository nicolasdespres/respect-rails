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

      def toggler(text, &block)
        @toggler_id ||= -1
        @toggler_id += 1
        toggler_key = "toggle_#@toggler_id"
        content_tag :div do
          result = content_tag(:div, class: "summary") do
            content_tag :a, text, href: "#", onclick: "return toggle(#@toggler_id)", id: "#{toggler_key}_toggle"
          end
          result << content_tag(:div, capture(&block), id: toggler_key, style: "display:none")
        end
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
