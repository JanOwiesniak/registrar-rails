Rails.application.routes.draw do
  # Delegate all OmniAuth callbacks to Registrar
  match 'auth/:strategy/callback' => 'registrar#callback', :via => [:get, :post]
  get 'sign_out' => 'registrar#sign_out'
end
