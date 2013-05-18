class AutomaticValidationControllerSchema < ApplicationControllerSchema
  def raise_no_method_error
    raise NoMethodError, "user has raised NoMethodError"
  end

  def raise_name_error
    raise NameError, "user has raised a NameError"
  end

  def only_documentation
    documentation <<-EOS
      Request with no schema but a documentation.

      It should be documented even if it does not have any schema defined.
    EOS
  end

end
