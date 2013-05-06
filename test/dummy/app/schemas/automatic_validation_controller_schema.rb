class AutomaticValidationControllerSchema < ApplicationControllerSchema
  def basic_get
    request do |r|
      r.query_parameters do |s|
        s.doc <<-EOS.strip_heredoc
          A parameter

          An important parameter that should be equal to 42.
          Yes really!.
          EOS
        s.integer "param1", equal_to: 42
      end
    end
    response_for do |status|
      status.ok do |r|
        r.body do |s|
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
      status.ok do |r|
        r.body do |s|
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
    request do |r|
      r.query_parameters do |s|
        s.string "param1", equal_to: "42"
      end
    end
  end

  def composite_custom_types
    request do |r|
      r.query_parameters do |s|
        s.circle "circle"
        s.rgba "color"
      end
    end
  end

  def default_response_schema_in_file
    # - No request schema defined.
    # - Default response for :ok is defined in automatic_validation/default_response_in_file.schema
  end

  def request_contextual_error
    request do |r|
      r.query_parameters do |s|
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
      status.is 200 do |r|
        r.body do |s|
          s.object "o1" do |s|
            s.object "o2" do |s|
              s.integer "i", equal_to: 51
            end
          end
        end
      end
    end
  end

  def request_format
    request do |r|
      r.query_parameters do |s|
        s.integer "id", required: false
      end
    end
    response_for do |status|
      status.is :ok do |r|
        r.body do |s|
          s.integer "id", equal_to: 42
        end
      end
    end
  end

  def basic_post
    request do |r|
      r.path_parameters do |s|
        s.integer "path_param", equal_to: 42
      end
      r.body_parameters do |s|
        s.integer "body_param", equal_to: 42
      end
    end
    response_for do |status|
      status.ok do |r|
        r.body do |s|
          s.integer "id", equal_to: 42
        end
      end
    end
  end

end
