Respect::Rails::Engine.routes.draw do
  root to: 'respect#index', via: :get, format: 'html'
  match '/doc' => 'respect#index', via: :get, as: 'doc'
end
