class DisabledSchema < Respect::Rails::ActionSchema
  def basic
    define_request do |r|
      r.params do |s|
        s.integer "param1", equal_to: 42
      end
    end
    response_for do |status|
      status.ok do |r|
        r.body do |s|
          s.object do |s|
            s.integer "id", equal_to: 42
          end
        end
      end
    end
  end
end
