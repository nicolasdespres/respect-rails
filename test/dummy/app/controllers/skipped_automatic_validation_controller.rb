# A controller disabling the automatic validation filter
# installed in the super class.
class SkippedAutomaticValidationController < AutomaticValidationController
  skip_around_filter :validate_schemas

  # GET /automatic_validation/basic_get.json
  def basic_get
    unless params['param1'] == 42
      raise "will be raised since the validator is disabled"
    end
    respond_to do |format|
      format.json do
        result = { id: 42 }
        render json: result
      end
    end
  end

end
