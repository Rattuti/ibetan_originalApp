Rails.application.routes.draw do
  constraints format: :json do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      registrations: 'auth/registrations',
      sessions: 'auth/sessions'  # 明示的に追加
    }
  end

  mount ActionCable.server => '/cable'

  namespace :auth do
    get 'me', to: 'sessions#me' # ログインユーザー情報取得API
    resources :registrations, only: [:create]
  end

  namespace :api do
    resources :users, only: [:index, :update, :destroy]
    resources :scraping, only: [:index]
    resources :events, only: [:index, :show, :create, :destroy, :update]
    resources :contacts, only: [:create]
  end  

  resources :articles, only: [:index, :show] do
    resources :favorites, only: [:create, :update, :destroy], shallow: true
  end

  resources :messages, only: [:index] do
    resources :likes, only: [:create, :destroy]
  end
end
