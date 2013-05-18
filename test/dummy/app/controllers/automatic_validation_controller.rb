# An example of automatic validation using the "validate_schemas" around filter.
class AutomaticValidationController < ApplicationController
  around_filter :validate_schemas!
  before_filter :sanitize_params!

  # GET /automatic_validation/basic_get.json
  def_action_schema :basic_get do |s|
    s.documentation <<-EOS
      A title.

      A description.
      EOS
    s.request do |r|
      r.query_parameters do |s|
        s.doc <<-EOS.strip_heredoc
          A parameter

          An important parameter that should be equal to 42.
          Yes really!.
          EOS
        s.integer "param1", equal_to: 42
      end
    end
    s.response_for do |status|
      status.ok do |r|
        r.body do |s|
          s.integer "id", equal_to: 42
        end
      end
    end
  end

  def basic_get
    unless params['param1'] == 42
      raise "should never be raised since the validator has raised one when checking parameters."
    end
    unless request.query_parameters[:param1] == 42
      raise "should never be raised since the validator has sanitized query_parameters"
    end
    respond_to do |format|
      format.json do
        result = { id: 42 }
        render json: result
      end
    end
  end

  # GET /automatic_validation/no_schema.json
  def no_schema_at_all
    respond_to do |format|
      format.json do
        render json: {}
      end
    end
  end

  def_action_schema :no_request_schema do |s|
    s.response_for do |status|
      status.ok do |r|
        r.body do |s|
          s.integer "id", equal_to: 42
        end
      end
    end
  end

  def no_request_schema
    respond_to do |format|
      format.json do
        result = { id: params[:returned_id] }
        render json: result, status: 200
      end
    end
  end


  def_action_schema :response_schema_from_file do |s|
    # - No request schema defined.
    # - Response for status ok is defined in the associated file.
  end

  def response_schema_from_file
    respond_to do |format|
      format.json do
        if params[:failure]
          result = { error: "failure" }
          render json: result, status: :unprocessable_entity
        else
          result = { id: params[:returned_id] }
          render json: result, status: :created
        end
      end
    end
  end

  def_action_schema :response_schema_from_file_unknown_status do |s|
    # - No request schema defined.
    # - Response for status ok is defined in the associated file.
  end

  def response_schema_from_file_unknown_status
    respond_to do |format|
      format.json do
        result = { id: params[:returned_id] }
        render json: result, status: :foo
      end
    end
  end

  # Route constraints prevent this endpoint to raise any validation error.
  def_action_schema :route_constraints do |s|
    s.request do |r|
      r.query_parameters do |s|
        s.string "param1", equal_to: "42"
      end
    end
  end

  def route_constraints
    unless params['param1'] == "42"
      raise "should never be rasised since the route has a constraint on this parameter value."
    end
    respond_to do |format|
      format.json do
        result = { id: 42 }
        render json: result
      end
    end
  end

  # Composite custom types like Circle and Point are expected in the parameters of this request.
  def_action_schema :composite_custom_types do |s|
    s.request do |r|
      r.query_parameters do |s|
        s.circle "circle"
        s.rgba "color"
      end
    end
  end

  def composite_custom_types
    expected_circle = Circle.new(Point.new(1.0, 2.0), 5.0)
    circle = params[:circle]
    unless circle == expected_circle
      raise "parameter circle '#{circle.inspect}' is not equal to '#{expected_circle.inspect}'"
    end
    expected_color = Rgba.new(0.0, 0.1, 0.2, 0.3)
    color = params[:color]
    unless color == expected_color
      raise "parameter color '#{color.inspect}' is not equal to '#{expected_color.inspect}'"
    end
    respond_to do |format|
      format.json do
        render json: true, status: :ok
      end
    end
  end

  def dump_uri_helpers
    result = {
      respect_path: respect_path,
      respect: {
        doc_path: respect.doc_path,
        root_path: respect.root_path,
      }
    }
    respond_to do |format|
      format.json do
        render json: result, status: :ok
      end
    end
  end

  def_action_schema :default_response_schema_in_file do |s|
    # - No request schema defined.
    # - Default response for :ok is defined in automatic_validation/default_response_in_file.schema
  end

  def default_response_schema_in_file
    respond_to do |format|
      format.json do
        if params[:failure]
          result = { error: "failure" }
          render json: result, status: :unprocessable_entity
        else
          result = { id: 42 }
          render json: result, status: :ok
        end
      end
    end
  end

  def_action_schema :request_contextual_error do |s|
    s.request do |r|
      r.query_parameters do |s|
        s.hash "o1" do |s|
          s.hash "o2" do |s|
            s.integer "i", equal_to: 42
          end
        end
      end
    end
  end

  def request_contextual_error
    raise "Error should be raised before me!!"
  end

  def_action_schema :response_contextual_error do |s|
    s.response_for do |status|
      status.is 200 do |r|
        r.body do |s|
          s.hash "o1" do |s|
            s.hash "o2" do |s|
              s.integer "i", equal_to: 51
            end
          end
        end
      end
    end
  end

  def response_contextual_error
    respond_to do |format|
      format.json do
        result = { o1: { o2: { i: 42 } } }
        render json: result, status: :ok
      end
    end
  end

  def_action_schema :request_format do |s|
    s.request do |r|
      r.query_parameters do |s|
        s.integer "id", required: false
      end
    end
    s.response_for do |status|
      status.is :ok do |r|
        r.body do |s|
          s.integer "id", equal_to: 42
        end
      end
    end
  end

  def request_format
    respond_to do |format|
      format.json do
        render json: { id: 42 }, status: :ok
      end
      format.html # request_format.html.erb
      format.pdf do
        render pdf: "foo", status: :ok
      end
    end
  end

  # POST /automatic_validation/basic_post.json
  def_action_schema :basic_post do |s|
    s.request do |r|
      r.path_parameters do |s|
        s.integer "path_param", equal_to: 42
      end
      r.body_parameters do |s|
        s.integer "body_param", equal_to: 42
      end
    end
    s.response_for do |status|
      status.ok do |r|
        r.body do |s|
          s.integer "id", equal_to: 42
        end
      end
    end
  end

  def basic_post
    unless params['path_param'] == 42
      raise "should never be raised since the validator has raised one before when checking path_param"
    end
    unless params['body_param'] == 42
      raise "should never be raised since the validator has raised one before when checking body_param"
    end
    unless request.path_parameters['path_param'] == 42
      raise "should never be raised since the validator has sanitized path_parameters"
    end
    unless request.body_parameters['body_param'] == 42
      raise "should never be raised since the validator has sanitized body_parameters"
    end
    respond_to do |format|
      format.json do
        result = { id: request.request_parameters['response_param'] }
        render json: result
      end
    end
  end

  def check_request_headers
    unless request.headers["test_header"] == "value"
      raise "should never be raised since the validator has raised one before when checking headers"
    end
    respond_to do |format|
      format.json do
        render json: {}
      end
    end
  end

  def check_response_headers
    headers["response_header"] = params["response_header"]
    respond_to do |format|
      format.json do
        render json: {}
      end
    end
  end

  def only_documentation
    respond_to do |format|
      format.json do
        render json: {}
      end
    end
  end
end
