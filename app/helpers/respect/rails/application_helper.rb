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
          result = "<span>{</span>"
          indent do
            result << newline
            keys = json.keys
            keys.each_with_index do |key, i|
              result << "<span>#{key.to_s.inspect}</span><span>:</span> "
              result << dump_json(json[key])
              if i < keys.size - 1
                result << "<span>,</span>"
                result << newline
              end
            end
          end
          result << newline
          result << "<span>}</span>"
          result
        end

        def dump_array(json)
          result = "<span>[</span>"
          indent do
            result << newline
            json.each_with_index do |item, i|
              result << dump_json(item)
              if i < json.size - 1
                result << "<span>,</span>"
                result << newline
              end
            end
          end
          result << newline
          result << "<span>]</span>"
          result
        end

        def dump_terminal(json)
          "<span>#{json.inspect}</span>"
        end
      end

      def highlight_json_schema(json_schema)
        JsonSchemaHighlighter.new.dump(json_schema).html_safe
      end

    end
  end
end
