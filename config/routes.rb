Rails.application.routes.draw do
  root to: 'games#index'

  resources :games, except: [:update, :edit, :delete] do
    resources :turns, only: :create
  end
end