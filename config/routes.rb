Rails.application.routes.draw do
  root "dashboard#index"

  resources :reviews, only: :create
  resource :simulator, only: [] do
    post :start
    post :stop
  end

  mount ActionCable.server => "/cable"
end

