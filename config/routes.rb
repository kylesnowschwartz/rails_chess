Rails.application.routes.draw do
  devise_for :players
  root to: 'games#index'

  resources :games, except: [:update, :edit, :delete] do
    resources :turns, only: :create
  end
end