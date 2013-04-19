# A controller with default schema loading filter disable
# validates any way if "validate_schemas" filter is set.
class DisabledController < ApplicationController
  # Skipping this filter like this is a bad idea since validation
  # will never happens. We do this only for test purpose. The only
  # advantage is to save schema loading time.
  skip_around_filter :load_schemas
  around_filter :validate_schemas

  # GET /disabled/basic.json
  def basic
    respond_to do |format|
      format.json do
        result = { id: 42 }
        render json: result
      end
    end
  end

end
