# A controller with default schema loading filter disable
# validates any way if "validate_schemas" filter is set.
class DisabledController < ApplicationController
  # Skipping this filter like this is a bad idea since validation
  # will never happens. We do this only for test purpose. The only
  # advantage is to save schema loading time.
  skip_around_filter :load_schemas!
  around_filter :validate_schemas!

  # GET /disabled/basic.json
  def_action_schema :basic do |s|
    s.request do |r|
      r.body_parameters do |s|
        s.integer "param1", equal_to: 42
      end
    end
    s.response_for do |status|
      status.ok do |r|
        r.body hash: false do |s|
          s.hash do |s|
            s.integer "id", equal_to: 42
          end
        end
      end
    end
  end

  def basic
    respond_to do |format|
      format.json do
        result = { id: 42 }
        render json: result
      end
    end
  end

end
