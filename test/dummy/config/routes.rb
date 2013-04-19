Rails.application.routes.draw do
  root to: 'automatic_validation#basic_get', param1: 42, format: 'json'
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

  mount Respect::Rails::Engine => "/rest_spec"
end
