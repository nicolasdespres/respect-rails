module Respect
  module ApplicationMacros
    def contact_attributes
      string "name"
      integer "age"
      uri "homepage"
    end
  end
end
