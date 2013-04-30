class ContactsControllerSchema < ApplicationControllerSchema
  def create
    request do
      body_params do |s|
        s.object "contact" do |s|
          s.contact_attributes
        end
      end
    end
    response_for do |status|
      status.ok # contacts/create.schema
      status.unprocessable_entity do
        body_with_object do |s|
          s.string "error"
        end
      end
    end
  end
end
