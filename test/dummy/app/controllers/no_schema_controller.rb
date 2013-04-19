# A controller with no associated schema.
class NoSchemaController < ApplicationController

  # GET /no_schema/basic.json
  def basic
    unless request.respond_to?(:validate_schema?)
      raise "request is instrumented even if no schema defined"
    end
    respond_to do |format|
      format.json do
        result = { id: 42 }
        render json: result
      end
    end
  end

end
