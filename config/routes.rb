Rails.application.routes.draw do
  use_doorkeeper
  devise_for :users,
             controllers: { omniauth_callbacks: 'oauth_callbacks' }

  root to: 'questions#index'

  concern :votable do
    member do
      post 'vote_up'
      post 'vote_down'
      patch 'vote_reset'
    end
  end

  concern :commentable do
    member do
      post 'add_comment'
    end
  end

  resources :questions, concerns: %i[votable commentable], shallow: true do
    resources :answers, concerns: %i[votable commentable], shallow: true do
      patch 'favorite', on: :member
    end
  end

  resources :attachments, only: :destroy

  resources :rewards, only: %i[index]

  namespace :api do
    namespace :v1 do
      resources :profiles, only: %i[index] do
        get :me, on: :collection
      end

      resources :questions, shallow: true do
        resources :answers
      end
    end
  end

  mount ActionCable.server => '/cable'
end

