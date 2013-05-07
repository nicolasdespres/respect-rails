Rails.application.routes.draw do
  root to: 'automatic_validation#basic_get', param1: 42, format: 'json'
  match 'request_format' => "automatic_validation#request_format", via: :get
  match 'automatic_validation/basic_post/:path_param' => "automatic_validation#basic_post", via: :post
  scope format: true, constraints: { format: 'json' }, via: :get do
    scope controller: 'automatic_validation', path: '/automatic_validation', as: "automatic_validation" do
      match 'basic_get'
      match 'no_schema_at_all'
      match 'no_request_schema'
      match 'response_schema_from_file'
      match 'response_schema_from_file_unknown_status'
      match 'route_constraints',
            constraints: lambda { |req| req.params["param1"] == "42" }
      match 'composite_custom_types'
      match 'dump_uri_helpers'
      match 'default_response_schema_in_file'
      match 'request_contextual_error'
      match 'response_contextual_error'
      match 'check_request_headers'
      match 'check_response_headers'
    end
    scope controller: 'manual_validation', path: 'manual_validation', as: "manual_validation" do
      match 'raise_custom_error'
      match 'raise_custom_error_without_rescue'
      match 'no_schema'
    end
    match '/no_schema/basic' => 'no_schema#basic'
    match '/no_exception/basic' => 'no_exception#basic'
    match '/disabled/basic' => 'disabled#basic'
    match '/skipped_automatic_validation/basic_get' => 'skipped_automatic_validation#basic_get'
  end
  match 'caught_exception/request_validator' => "caught_exception#request_validator", via: :get
  match 'caught_exception/response_validator' => "caught_exception#response_validator", via: :get

  mount Respect::Rails::Engine => "/rest_spec"
end
