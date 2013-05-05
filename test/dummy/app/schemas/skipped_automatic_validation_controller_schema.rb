class SkippedAutomaticValidationControllerSchema < Respect::Rails::ActionSchema
  def basic_get
    request do |r|
      r.body_params do |s|
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
end
