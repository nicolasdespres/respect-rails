class ContactsControllerSchema < ApplicationControllerSchema
  def create
    doc <<-EOS.strip_heredoc
      Create a new contact in the address book.

      This request create a new contact in the database with all the
      attributes provided and respond its full description including
      some more attributes.
    EOS
    request do |r|
      r.body_parameters do |s|
        s.hash "contact" do |s|
          s.contact_attributes
        end
      end
    end
    response_for do |status|
      status.ok # contacts/create.schema
      status.unprocessable_entity do |s|
        s.body do |s|
          s.string "error"
        end
      end
    end
  end
end
