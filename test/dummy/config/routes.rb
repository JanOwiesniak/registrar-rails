Rails.application.routes.draw do
  mount Registrar::Rails::Engine => "/registrar"

  get "some/index" => "some#index"
end
