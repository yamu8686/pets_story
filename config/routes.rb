Rails.application.routes.draw do

  namespace :public do
    resources :post_images, only: [:new, :create, :index, :show, :edit, :update, :destroy]
  end
  root to: 'homes#top'
  get "/about" => "homes#about", as: "about"

  devise_for :admin, skip: [:registrations, :passwords], controllers: {
    sessions: "admin/sessions"
  }

  devise_for :users, skip: [:passwords], controllers: {
    registrations: "public/registrations",
    sessions: 'public/sessions'
  }


  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
