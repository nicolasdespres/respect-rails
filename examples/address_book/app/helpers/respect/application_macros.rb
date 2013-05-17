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
  end
end
