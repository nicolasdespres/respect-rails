Rails.application.routes.draw do

  mount Respect::Rails::Engine => "/rest_spec"
end
