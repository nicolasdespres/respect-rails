class AutomaticValidationControllerSchema < ApplicationControllerSchema
  def raise_no_method_error
    raise NoMethodError, "user has raised NoMethodError"
  end

  def raise_name_error
    raise NameError, "user has raised a NameError"
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
        s.hash "o1" do |s|
          s.hash "o2" do |s|
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
          s.hash "o1" do |s|
            s.hash "o2" do |s|
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

  def check_request_headers
    request do |r|
      r.headers do |h|
        h["test_header"] = "value"
      end
    end
  end

  def check_response_headers
    response_for do |status|
      status.ok do |r|
        r.headers do |h|
          h["response_header"] = "good"
        end
      end
    end
  end

  def only_documentation
    documentation <<-EOS
      Request with no schema but a documentation.

      It should be documented even if it does not have any schema defined.
    EOS
  end

end
