module Respect
  module ApplicationMacros
    def id(name = "id")
      integer name, greather_than: 0
    end

    def contact_attributes
      string "name"
      integer "age"
      uri "homepage"
    end

    def record_timestamps
      datetime "created_at"
      datetime "updated_at"
    end

    def contact(name = "contact")
      hash name do |s|
        s.id
        s.contact_attributes
        s.record_timestamps
      end
    end

    def error(name)
      array name, required: false do |s|
        s.string
      end
    end

    def contact_errors
      error "name"
      error "age"
      error "homepage"
    end
  end
end
