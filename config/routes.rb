Rails.application.routes.draw do

  root to: 'homes#top'
  get "/about" => "homes#about", as: "about"

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }

  namespace :public do
    resources :users, only: [:index, :show, :edit, :update]do
      resource :relationships, only: [:create, :destroy]
      get 'followings' => 'public/relationships#followings', as: 'followings'
      get 'followers' => 'public/relationships#followers', as: 'followers'
    end

    resources :post_images, only: [:new, :create, :index, :show, :edit, :update, :destroy] do
      resources :post_comments, only: [:create, :destroy]
      resource :favorites, only: [:create, :destroy]
      resources :reposts, only: [:create, :destroy]
    end

    resources :messages, only: [:create]
    resources :rooms, only: [:create, :index, :show]

    get '/search', to: 'searches#search'
  end
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
