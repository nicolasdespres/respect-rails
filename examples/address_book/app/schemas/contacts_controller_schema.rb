class ContactsControllerSchema < ApplicationControllerSchema
  def create
    request do
      body_parameters do |s|
        s.object "contact" do |s|
          s.contact_attributes
        end
      end
    end
    response_for do |status|
      status.ok # contacts/create.schema
      status.unprocessable_entity do
        body do |s|
          s.string "error"
        end
      end
    end
  end
end
