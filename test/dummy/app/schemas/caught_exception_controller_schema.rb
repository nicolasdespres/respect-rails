class CaughtExceptionControllerSchema < ApplicationControllerSchema
  def request_validator
    request do |r|
      r.body_params do |s|
        s.integer :id, equal_to: 42
      end
    end
  end

  def response_validator
    response_for do |status|
      status.ok do |r|
        r.body_with_object do |s|
          s.integer :id, equal_to: 42
        end
      end
    end
  end
end
