module Respect
  module ApplicationMacros
    def id(name = "id")
      integer name, greather_than: 0
    end

    def contact_attributes(options = {})
      doc <<-EOS.strip_heredoc
        The name of the contact.

        First name and last name are separated by white space.
        EOS
      string "name", options
      doc "How old is the contact."
      integer "age", options
      uri "homepage", options.merge(doc: "The URL of the contact's homepage")
    end

    def record_timestamps
      doc "When this record has been created."
      datetime "created_at"
      doc "When this record has been updated lastly."
      datetime "updated_at"
    end

    def contact
      doc "The identifier of this contact."
      id
      contact_attributes
      record_timestamps
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
