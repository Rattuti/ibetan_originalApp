Rails.application.routes.draw do
  # DeviseTokenAuth のルート
  mount_devise_token_auth_for 'User', at: 'auth', controllers: {
    registrations: 'auth/registrations',
    sessions: 'auth/sessions'
  }

  mount ActionCable.server => '/cable'

  # 一般ユーザー用エンドポイント
  namespace :api do
    resources :users, only: [:index, :show, :update, :destroy]
    resources :scraping, only: [:index]
    resources :events, only: [:index, :show, :create, :destroy, :update]
    resources :contacts, only: [:index, :show, :create] 
  end  

  # 管理者専用エンドポイント
  namespace :admin do
    resources :users, only: [:index, :update, :destroy]  # 管理者用のユーザー管理
  end

  resources :articles, only: [:index, :show] do
    resources :favorites, only: [:create, :update, :destroy], shallow: true
  end

    resources :messages, only: [:index, :create] do
      resource :like, only: [:create, :destroy] do# いいね機能 
        post :toggle, on: :collection   # collection に変更（idを使わない）
      end
    end

end
