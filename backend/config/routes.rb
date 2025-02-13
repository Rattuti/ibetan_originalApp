Rails.application.routes.draw do
  constraints format: :json do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      registrations: 'auth/registrations'
    }
  end

  mount ActionCable.server => '/cable'

  namespace :api do
    get 'users/me', to: 'users#me' # 現在のログインユーザー情報取得
  resources :users, only: [:index, :update, :destroy]
    resources :scraping, only: [:index]
    resources :events, only: [:index, :show, :create, :destroy, :update]
  end  

    resources :articles, only: ['index'] do
      member do
        resources :favorites, only: [:create, :update, :destroy]
      end
    end

    resources :messages, only: [:index] do
      resources :likes, only: [:create, :destroy]
    end

end
