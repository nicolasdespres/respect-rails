AddressBook::Application.routes.draw do
  mount Respect::Rails::Engine => "/rest_spec"
  resources :contacts


  root to: "home#index"

end
