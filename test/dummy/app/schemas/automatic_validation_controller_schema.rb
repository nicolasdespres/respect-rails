class AutomaticValidationControllerSchema < ApplicationControllerSchema
  def basic_get
    request do
      body_params do |s|
        s.doc <<-EOS.strip_heredoc
          A parameter

          An important parameter that should be equal to 42.
          Yes really!.
          EOS
        s.integer "param1", equal_to: 42
      end
    end
    response_for do |status|
      status.ok do
        body_with_object do |s|
          s.integer "id", equal_to: 42
        end
      end
    end
  end

  def raise_no_method_error
    raise NoMethodError, "user has raised NoMethodError"
  end

  def raise_name_error
    raise NameError, "user has raised a NameError"
  end

  def no_request_schema
    response_for do |status|
      status.ok do
        body_with_object do |s|
          s.integer "id", equal_to: 42
        end
      end
    end
  end

  def response_schema_from_file
    # - No request schema defined.
    # - Response for status ok is defined in the associated file.
  end

  def response_schema_from_file_unknown_status
    # - No request schema defined.
    # - Response for status ok is defined in the associated file.
  end

  def route_constraints
    request do
      body_params do |s|
        s.string "param1", equal_to: "42"
      end
    end
  end

  def composite_custom_types
    request do
      body_params do |s|
        s.circle "circle"
      end
    end
  end

  def default_response_schema_in_file
    # - No request schema defined.
    # - Default response for :ok is defined in automatic_validation/default_response_in_file.schema
  end

  def request_contextual_error
    request do
      body_params do |s|
        s.object "o1" do |s|
          s.object "o2" do |s|
            s.integer "i", equal_to: 42
          end
        end
      end
    end
  end

  def response_contextual_error
    response_for do |status|
      status.ok do
        body_with_object do |s|
          s.object "o1" do |s|
            s.object "o2" do |s|
              s.integer "i", equal_to: 51
            end
          end
        end
      end
    end
  end

end
