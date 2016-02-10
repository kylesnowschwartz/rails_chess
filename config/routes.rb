Rails.application.routes.draw do
  root to: 'games#index'

  resources :games, except: [:update, :edit, :delete] do
    resources :turns, only: :create
    resources :players, only: :update
  end
end