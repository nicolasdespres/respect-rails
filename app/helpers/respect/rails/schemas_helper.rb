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

      # FIXME(Nicolas Despres): Make me more generic to all enumerable and test me.
      def flat_each(hash, &block)
        flat_each_rec([], hash, &block)
      end

      def build_parameter_name(path)
        path.first.to_s + path[1..-1].reduce(""){|r, x| r + "[#{x}]" }
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
        when :strict
          if value
            "Must contains exactly these parameters"
          else
            nil
          end
        when :greater_than
          "Must be greater than #{value}"
        else
          "#{name}: #{value.inspect}"
        end
      end

      def flat_each_rec(path, hash, &block)
        hash.each do |k, v|
          block.call(path + [k], v)
          if v.is_a?(Respect::HashSchema)
            flat_each_rec(path + [k], v, &block)
          end
        end
      end
    end
  end
end
