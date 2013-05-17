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
  end
end
