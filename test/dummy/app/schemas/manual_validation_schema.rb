class ManualValidationSchema < Respect::Rails::ActionSchema
  def raise_custom_error
    request do |r|
      r.params do |s|
        s.integer "param1", equal_to: 42
      end
    end
    response_for do |status|
      status.ok do |r|
        r.body do |s|
          s.object do |s|
            s.integer "id", equal_to: 53
          end
        end
      end
    end
  end

  # FIXME(Nicolas Despres): Factor this schema with "raise_custom_error
  def raise_custom_error_without_rescue
    request do |r|
      r.params do |s|
        s.integer "param1", equal_to: 42
      end
    end
    response_for do |status|
      status.ok do |r|
        r.body_with_object do |s|
          s.integer "id", equal_to: 53
        end
      end
    end
  end
end
