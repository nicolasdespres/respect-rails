module Respect
  module Rails
    class RequestSchema

      class << self
        def define(*args, &block)
          RequestDef.eval(*args, &block)
        end
      end

      def initialize(controller, action)
        @controller = controller
        @action = action
        @default_path_parameters = HashSchema.define do |s|
          s.string "controller", equal_to: @controller.to_s, doc: false
          s.string "action", equal_to: @action.to_s, doc: false
        end
        @path_parameters = @default_path_parameters.dup
        @body_parameters = HashSchema.new
        @query_parameters = HashSchema.new
      end

      attr_reader :controller, :action

      attr_reader :body_parameters, :query_parameters

      attr_reader :path_parameters, :default_path_parameters

      # Merge +path_parameters+ with {#default_path_parameters} and store it.
      def path_parameters=(path_parameters)
        @path_parameters = @default_path_parameters.merge(path_parameters)
        @path_parameters.options[:strict] = false
        @path_parameters
      end

      [ :body, :query ].each do |name|
        eval <<-EOS
          def #{name}_parameters=(#{name}_parameters)
            @#{name}_parameters = #{name}_parameters
            @#{name}_parameters.options[:strict] = false
            @#{name}_parameters
          end
          EOS
      end

      # Validate the given +request+.
      # Raise a {RequestValidationError} if an error occur.
      # Returns +true+ on success.
      def validate(request)
        [ :path, :query, :body ].each do |name|
          begin
            send("#{name}_parameters").validate(request.params)
          rescue Respect::ValidationError => e
            raise RequestValidationError.new(e, name)
          end
        end
        true
      end

      def validate?(request)
        begin
          validate(request)
          true
        rescue RequestValidationError => e
          @last_error = e
          false
        end
      end

      # Return the last validation error that happens during the
      # validation process. (set by {#validate?})
      # Reset each time {#validate?} is called.
      attr_reader :last_error

      def validate!(request)
        valid = validate?(request)
        if valid
          [ :path, :query, :body ].each do |name|
            send("#{name}_parameters").sanitize_doc!(request.params)
            send("#{name}_parameters").sanitize_doc!(request.send("#{name}_parameters"))
          end
        end
        valid
      end

    end
  end
end
