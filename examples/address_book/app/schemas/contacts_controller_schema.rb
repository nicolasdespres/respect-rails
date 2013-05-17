class ContactsControllerSchema < ApplicationControllerSchema
  def index
    documentation <<-EOS.strip_heredoc
      List all the contacts in the address book.

      This request lists all the contacts recorded in the database with
      all their attributes.
    EOS
    response_for do |status|
      status.ok do |s|
        s.body hash: false do |s|
          s.array do |s|
            s.hash do |s|
              s.id
              s.contact_attributes
              s.datetime "created_at"
              s.datetime "updated_at"
            end
          end
        end
      end
    end
  end

  def show
    documentation <<-EOS.strip_heredoc
      Show a contacts in the address book.

      This request show the contacts identified by the given 'id'
      recorded in the database with all its attributes.
    EOS
    request do |r|
      r.path_parameters do |s|
        s.id
      end
    end
    response_for do |status|
      status.ok do |s|
        s.body do |s|
          s.id
          s.contact_attributes
          s.datetime "created_at"
          s.datetime "updated_at"
        end
      end
    end
  end

  def new
    documentation <<-EOS.strip_heredoc
      Create a new contact with default value and return it.

      This request create a new contact with default value but
      does not store it in the database. It simply return it in
      the response.
    EOS
    response_for do |status|
      status.ok do |s|
        s.body do |s|
          s.id
          s.contact_attributes
          s.datetime "created_at"
          s.datetime "updated_at"
        end
      end
    end
  end

  def create
    documentation <<-EOS.strip_heredoc
      Create a new contact in the address book.

      This request creates a new contact in the database with all the
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
      status.created # contacts/create-created.schema
      status.unprocessable_entity do |s|
        s.body do |s|
          s.string "error"
        end
      end
    end
  end

  def update
    documentation <<-EOS.strip_heredoc
      Update an existing contact in the address book.

      This request updates an existing contact identified by the given 'id'
      in the database with all the attributes provided and respond no content
      if it succeed.
    EOS
    request do |r|
      r.path_parameters do |s|
        s.id
      end
      r.body_parameters do |s|
        s.hash "contact" do |s|
          s.contact_attributes
        end
      end
    end
    response_for do |status|
      status.no_content do |s|
        # Empty schema
      end
      status.unprocessable_entity do |s|
        s.body do |s|
          s.string "error"
        end
      end
    end
  end
end
