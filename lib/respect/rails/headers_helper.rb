module Respect
  module Rails
    module HeadersHelper
      def has_key?(header_name)
        super || super(env_name(header_name))
      end
    end
  end
end

ActionDispatch::Http::Headers.send :include, Respect::Rails::HeadersHelper
