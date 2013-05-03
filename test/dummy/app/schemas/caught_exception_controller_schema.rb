class CaughtExceptionControllerSchema < ApplicationControllerSchema
  def request_validator
    request do |r|
      r.body_params do |s|
        s.integer :id, equal_to: 42
      end
    end
  end
end
