Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: 'users/registrations' }
  root to: 'homes#top'
  get 'home/about', to: 'homes#about'
  get '/information', to: 'information#index', as: 'information_index'
  post '/approve_request/:request_id', to: 'information#approve_request', as: 'approve_request'
  delete '/reject_request/:request_id', to: 'information#reject_request', as: 'reject_request'
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
