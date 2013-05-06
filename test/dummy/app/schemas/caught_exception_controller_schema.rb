class CaughtExceptionControllerSchema < ApplicationControllerSchema
  def request_validator
    request do |r|
      r.body_parameters do |s|
        s.integer :id, equal_to: 42
      end
    end
  end

  def response_validator
    response_for do |status|
      status.ok do |r|
        r.body do |s|
          s.integer :id, equal_to: 42
        end
      end
    end
  end
end
