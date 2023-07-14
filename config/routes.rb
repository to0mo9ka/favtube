Rails.application.routes.draw do
  devise_for :users
  root to: 'homes#top'
  get 'home/about', to: 'homes#about'
  resources :users, only: [:index, :show, :edit, :update]do
    member do
      get :follows, :followers
    end
    resource :relationships, only: [:create, :destroy]
  end

  resources :videos, only: [:index, :show, :create, :edit, :update, :destroy] do
    resource :favorites, only: [:create, :destroy]
    resources :post_comments, only: [:create, :destroy] do
      resource :favorite_comments, only: [:create, :destroy]
    end
  end
end
