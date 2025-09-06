Rails.application.routes.draw do
  get "up" => "rails/health#show", as: :rails_health_check

  match "/404", to: "errors#not_found", via: :all
  match "/500", to: "errors#internal_server_error", via: :all
  match "/422", to: "errors#unprocessable_entity", via: :all

  root 'products#index'
  resources :products do
    collection do
      get 'search'
    end
  end

  resources :orders

end
