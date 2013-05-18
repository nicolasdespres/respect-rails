class AutomaticValidationControllerSchema < ApplicationControllerSchema
  def raise_no_method_error
    raise NoMethodError, "user has raised NoMethodError"
  end

  def raise_name_error
    raise NameError, "user has raised a NameError"
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
