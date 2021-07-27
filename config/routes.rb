Rails.application.routes.draw do
  devise_for :users

  resources :questions, shallow: true do
    resources :answers, shallow: true do
      patch 'favorite', on: :member
    end
  end

  resources :attachments, only: :destroy

  resources :rewards, only: %i[index]

  root to: 'questions#index'
end
