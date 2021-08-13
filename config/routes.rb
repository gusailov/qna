Rails.application.routes.draw do
  devise_for :users

  concern :votable do
    member do
      post 'vote_up'
      post 'vote_down'
      patch 'vote_reset'
    end
  end

  resources :questions, concerns: [:votable], shallow: true do
    resources :answers, concerns: [:votable], shallow: true do
      patch 'favorite', on: :member
    end
  end

  resources :attachments, only: :destroy

  resources :rewards, only: %i[index]

  root to: 'questions#index'
end
