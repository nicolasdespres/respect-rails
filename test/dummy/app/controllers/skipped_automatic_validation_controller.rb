# A controller disabling the automatic validation filter
# installed in the super class.
class SkippedAutomaticValidationController < AutomaticValidationController
  skip_around_filter :validate_schemas!
  skip_before_filter :sanitize_params!

  # GET /automatic_validation/basic_get.json
  def_action_schema :basic_get do |s|
    s.request do |r|
      r.body_parameters do |s|
        s.integer "param1", equal_to: 42
      end
    end
    s.response_for do |status|
      status.ok do |r|
        r.body do |s|
          s.integer "id", equal_to: 42
        end
      end
    end
  end

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
