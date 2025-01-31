Rails.application.routes.draw do
  constraints format: :json do
    mount_devise_token_auth_for 'User', at: 'auth', controllers: {
      registrations: 'auth/registrations'
    }

    resources :messages, only: ['index'] do
      member do
        resources :bookmarks, only: ['create']
      end
    end

    resources :messages, only: ['index'] do
      member do
        resources :favorites, only: ['create']
      end
    end

    resources :articles, only: ['index'] do
      member do
        resources :bookmarks, only: ['create']
      end
    end

    resources :favorites, only: ['destroy']
    resources :bookmarks, only: ['destroy']

  end
end
