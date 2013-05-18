module Respect
  module Rails
    module HeadersSimplifier
      # Copy the given +headers+ hash table but get rid of the
      # _complex_ type at the same time.
      #
      # This is useful if you plan to serialize +headers+ and want to
      # get rid of complex type which may raise errors when serializing.
      def simplify_headers(headers)
        case headers
        when String, Numeric, TrueClass, FalseClass, Symbol, Mime::Type
          headers
        when Array
          result = []
          headers.each do |x|
            v = simplify_headers(x)
            result << v if v
          end
          result
        when Hash
          result = {}
          headers.each do |k, v|
            new_v = simplify_headers(v)
            result[k] = new_v if new_v
          end
          result
        end
      end
    end # module HeadersSimplifier
  end # module Rails
end # module Respect
