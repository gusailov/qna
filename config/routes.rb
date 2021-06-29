Rails.application.routes.draw do
  devise_for :users
  resources :questions, shallow: true do
    resources :answers, shallow: true do
      patch 'favorite', on: :member
    end
  end

  root to: 'questions#index'
end
