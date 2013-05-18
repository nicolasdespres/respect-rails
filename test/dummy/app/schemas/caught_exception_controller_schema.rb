class CaughtExceptionControllerSchema < ApplicationControllerSchema

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
