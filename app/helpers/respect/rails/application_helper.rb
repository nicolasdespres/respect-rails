module Respect
  module Rails
    module ApplicationHelper

      # FIXME(Nicolas Despres): Move to its own file and add unit test.
      class JsonSchemaHighlighter
        def initialize
          @indent_level = 0
          @indent_size = 2
        end

        def dump(json)
          result = %q{<div class="highlight"><pre>}
          result << dump_json(json)
          result << "</pre></div>"
        end

        private

        def indent(&block)
          @indent_level += 1
          block.call
          @indent_level -= 1
        end

        def newline
          "\n#{indentation}"
        end

        def indentation
          " " * @indent_level * @indent_size
        end

        def dump_json(json)
          case json
          when Hash
            dump_hash(json)
          when Array
            dump_array(json)
          else
            dump_terminal(json)
          end
        end

        def dump_hash(json)
          result = plain_text("{")
          indent do
            result << newline
            keys = json.keys
            keys.each_with_index do |key, i|
              if json[key].is_a? Hash
                doc = ""
                if json[key].key? "title"
                  doc << json[key]["title"]
                  json[key].delete("title")
                end
                if json[key].key? "description"
                  doc << "\n\n"
                  doc << json[key]["description"]
                  json[key].delete("description")
                end
                unless doc.empty?
                  result << comment(doc)
                  result << newline
                end
              end
              result << span("key", key.to_s.inspect) << plain_text(":") << " "
              result << dump_json(json[key])
              if i < keys.size - 1
                result << plain_text(",")
                result << newline
              end
            end
          end
          result << newline
          result << plain_text("}")
          result
        end

        def dump_array(json)
          result = plain_text("[")
          indent do
            result << newline
            json.each_with_index do |item, i|
              result << dump_json(item)
              if i < json.size - 1
                result << plain_text(",")
                result << newline
              end
            end
          end
          result << newline
          result << plain_text("]")
          result
        end

        def dump_terminal(json)
          css = (case json
                 when TrueClass, FalseClass
                   "keyword"
                 when String
                   "string"
                 when Numeric
                   "numeric"
                 else
                   "plain"
                 end)
          span(css, json.inspect)
        end

        def plain_text(text)
          span("plain", text)
        end

        def tag(tag, klass, value)
          "<#{tag} class=\"#{klass}\">#{value}</#{tag}>"
        end

        def span(klass, value)
          tag("span", klass, value)
        end

        def comment(text)
          s = text.dup
          s.sub!(/\n*\Z/m, '')
          s.gsub!(/\n/m, "\n#{indentation}// ")
          span("comment", "// #{s}")
        end
      end

      def highlight_json_schema(json_schema)
        JsonSchemaHighlighter.new.dump(json_schema).html_safe
      end

    end
  end
end
