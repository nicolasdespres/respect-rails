Respect::Rails::Engine.routes.draw do
  root to: 'schemas#index', via: :get, format: 'html'
  match '/doc' => 'schemas#doc', via: :get, as: 'doc'
end
