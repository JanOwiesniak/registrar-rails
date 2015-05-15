Rails.application.routes.draw do
  get 'sign_up', :to => 'authentication#sign_up', :as => 'sign_up'
  get 'sign_in', :to => 'authentication#sign_in', :as => 'sign_in'

  # Auth through OmniAuth strategy
  post 'auth/:strategy/callback' => 'authentication#authenticate'
  get 'auth/:strategy/callback' => 'authentication#authenticate'
end
