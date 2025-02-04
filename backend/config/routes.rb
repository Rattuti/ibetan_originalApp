Rails.application.routes.draw do
  constraints format: :json do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      registrations: 'auth/registrations'
    }
  end

  mount ActionCable.server => '/cable'

  namespace :api do
    resources :scraping, only: [:index]
    resources :events, only: [:index, :show, :create, :destroy]
  end  

    resources :events, only: [:index, :create, :update]

    resources :articles, only: ['index'] do
      member do
        resources :favorites, only: [:create, :update, :destroy]
      end
    end

    resources :messages, only: [:index] do
      resources :likes, only: [:create, :destroy]
    end

end
