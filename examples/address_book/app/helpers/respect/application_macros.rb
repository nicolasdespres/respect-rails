module Respect
  module ApplicationMacros
    # A helper to specify the JSON schema of an identifier parameter key.
    def id(name = "id")
      integer name, greather_than: 0
    end

    # A macro specifying the JSON schema of all 'contacts' attributes.
    def contact_attributes(options = {})
      with_options options do
        # Specify the 'name' attribute
        doc <<-EOS.strip_heredoc
          The name of the contact.

          First name and last name are separated by white space.
          EOS
        string "name"
        # Specify the 'age' attribute.
        doc "How old is the contact."
        integer "age"
        # Specify the 'homepage' attribute.
        uri "homepage", doc: "The URL of the contact's homepage"
      end
    end

    # A macro specifying JSON schema of the record timestamps used by Rails.
    def record_timestamps
      doc "When this record has been created."
      datetime "created_at"
      doc "When this record has been updated lastly."
      datetime "updated_at"
    end

    # Specify the JSON schema of a contact when shown in a response.
    def contact
      doc "The identifier of this contact."
      id
      contact_attributes
      record_timestamps
    end

    # Specify the JSON schema of an error reported by ActiveRecord.
    def error(name)
      array name, required: false do |s|
        s.string
      end
    end

    # Specify the JSON schema of an error responses when we failed
    # to create/update a 'contact' record.
    def contact_errors
      error "name"
      error "age"
      error "homepage"
    end
  end
end
