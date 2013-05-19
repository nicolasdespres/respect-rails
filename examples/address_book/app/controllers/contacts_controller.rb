class ContactsController < ApplicationController
  # GET /contacts
  # GET /contacts.json
  def_action_schema :index do |a|
    a.documentation <<-EOS.strip_heredoc
      List all the contacts in the address book.

      This request lists all the contacts recorded in the database with
      all their attributes.
    EOS
    a.response_for do |status|
      status.ok do |s|
        # The JSON schema of the response body when status is 'ok' is
        # an array of contact hash. Something like:
        #   [ { id: 123, name: "Albert", ...}, {...} ]
        s.body hash: false do |s|
          s.array do |s|
            s.hash do |s|
              # +contact+ is a method defined in +Respect::ApplicationMacros+ helper.
              s.contact
            end
          end
        end
      end
    end
  end
  def index
    @contacts = Contact.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @contacts }
    end
  end

  # GET /contacts/1
  # GET /contacts/1.json
  def_action_schema :show do |a|
    a.documentation <<-EOS.strip_heredoc
      Show a contacts in the address book.

      This request show the contacts identified by the given 'id'
      recorded in the database with all its attributes.
    EOS
    a.request do |r|
      # The 'id' parameter is passed in the URL path.
      r.path_parameters do |s|
        s.id
      end
    end
    a.response_for do |status|
      status.ok do |s|
        # The JSON schema of the response body when status is 'ok' is
        # contact hash. Something like:
        #   {
        #     id: 123,
        #     name: "Albert",
        #     age: 42,
        #     homepage: "http::/example.org",
        #     created_at: "}
        s.body do |s|
          s.contact
        end
      end
    end
  end
  def show
    @contact = Contact.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @contact }
    end
  end

  # GET /contacts/new
  # GET /contacts/new.json
  def_action_schema :new do |a|
    a.documentation <<-EOS.strip_heredoc
      Create a new contact with default value and return it.

      This request create a new contact with default value but
      does not store it in the database. It simply return it in
      the response.
    EOS
    a.response_for do |status|
      status.ok do |s|
        s.body do |s|
          s.contact_attributes allow_nil: true, required: true
        end
      end
    end
  end
  def new
    @contact = Contact.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @contact }
    end
  end

  # GET /contacts/1/edit
  def edit
    @contact = Contact.find(params[:id])
  end

  # POST /contacts
  # POST /contacts.json
  def_action_schema :create do |a|
    a.documentation <<-EOS.strip_heredoc
      Create a new contact in the address book.

      This request creates a new contact in the database with all the
      attributes provided and respond its full description including
      some more attributes.
    EOS
    a.request do |r|
      # Specify the headers that must be present when sending this request.
      r.headers do |h|
        # User must provide an API public key to do this request.
        h.doc "Set this header."
        h['X-AB-Signature'] = "api_public_key"
      end
      # The parameters are sent in the body part of the request.
      r.body_parameters do |s|
        # They look like something like that:
        #   { contact: { name: "Albert", age: 62, homepage: "http://example.org" }
        s.hash "contact" do |s|
          # This macros is defined in +Respect::ApplicationMacros+.
          s.contact_attributes
        end
      end
    end
    a.response_for do |status|
      # The JSON schema of the response body when the status is 'created'
      # is the full representation of the contact.
      status.created do |s|
        s.documentation <<-EOS
          Success.

          The contact has been correctly created. All the recorded attributes are returned.
        EOS
        s.body do |s|
          s.contact
        end
      end
      status.unprocessable_entity do |s|
        s.documentation <<-EOS
          Failure.

          An error occurred and prevented the contact from being created. The error are detailed in the
          response. Each error is attached to its related attribute.
        EOS
        s.body do |s|
          s.contact_errors
        end
      end
    end
  end
  def create
    @contact = Contact.new(params[:contact])

    respond_to do |format|
      if @contact.save
        format.html { redirect_to @contact, notice: 'Contact was successfully created.' }
        format.json { render json: @contact, status: :created, location: @contact }
      else
        format.html { render action: "new" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /contacts/1
  # PUT /contacts/1.json
  def_action_schema :update do |a|
    a.documentation <<-EOS.strip_heredoc
      Update an existing contact in the address book.

      This request updates an existing contact identified by the given 'id'
      in the database with all the attributes provided and respond no content
      if it succeed.
    EOS
    a.request do |r|
      r.path_parameters do |s|
        s.id
      end
      r.body_parameters do |s|
        s.hash "contact" do |s|
          s.contact_attributes required: false
        end
      end
    end
    a.response_for do |status|
      status.no_content do |s|
        s.documentation <<-EOS
          Success.

          The contact has been correctly updated.
        EOS
      end
      status.unprocessable_entity do |s|
        s.documentation <<-EOS
          Failure.

          An error occurred and prevented the contact from being updated. The error are detailed in the
          response. Each error is attached to its related attribute.
        EOS
        s.body do |s|
          s.contact_errors
        end
      end
    end
  end
  def update
    @contact = Contact.find(params[:id])

    respond_to do |format|
      if @contact.update_attributes(params[:contact])
        format.html { redirect_to @contact, notice: 'Contact was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: "edit" }
        format.json { render json: @contact.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /contacts/1
  # DELETE /contacts/1.json
  def_action_schema :destroy do |a|
    a.documentation <<-EOS.strip_heredoc
      Destroy an existing contact in the address book.

      This request destroy an existing contact identified by the given 'id'
      in the database. No content is responded.
    EOS
    a.request do |r|
      r.path_parameters do |s|
        s.id
      end
    end
    a.response_for do |status|
      status.no_content do |s|
        # Empty schema
      end
    end
  end
  def destroy
    @contact = Contact.find(params[:id])
    @contact.destroy

    respond_to do |format|
      format.html { redirect_to contacts_url }
      format.json { head :no_content }
    end
  end
end
