Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => "registrations" }
  resources :categories do
    collection do
      get "new", to: "categories#new", as: "new"
      get ":slug", to: "categories#get_by_slug", as: "by_slug"
    end
  end

  get 'users/index'
  get 'users/show'

  resources :media
  resources :exercises do
    resources :comments, module: :exercises
    collection do
      post "search"
      get "me"
      get ":id/edit/:step", to: "exercises#edit", as: "edit_with_step"
      get "new/:step", to: "exercises#new", as: "new_with_step"

      get ":id/practice/add(/:time)", to: "exercises#add_to_practice", as: "add_to_practice"
      put ":id/favorites/add", to: "exercises#add_to_favorites"
      put ":id/favorites/remove", to: "exercises#remove_from_favorites"
    end
  end

  resources :sessions_of_the_days
  resources :comments do
    resources :comments, module: :comments
  end

  root "exercises#index"

  get "users/:id", to: "users#show", as: "user"
  delete "users/:id/delete_avatar", to: "users#delete_avatar", as: "delete_avatar"

  # Here because use turbo ??
  get "exercises/:id/versions", to: "exercises#get_versions_list", as: "list_versions"
  delete "exercises/:index/practice/remove/:sessions_of_the_day_id/:session_index", to: "exercises#remove_from_practice", as: "remove_from_practice"

  get "sessons_of_the_days/previous(/:id)", to: "sessions_of_the_days#get_previous", as: "previous_session"
  get "sessons_of_the_days/next(/:id)", to: "sessions_of_the_days#get_next", as: "next_session"

  # Media
  # mount MediumUploader.download_endpoint => "/uploads"

  # Pages
  get "/pages/:slug", to: "pages#show", as: "page"

  # Friendships
  delete "friendship/remove/:id", to: "friendships#destroy", as: "remove_friendship"
  post "friendship/request/:id", to: "friendships#create", as: "friendship_request"
  put "friendship/accept/:id", to: "friendships#accept", as: "accept_friendship"

  # Errors routes
  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#internal_server'
  get '/422', to: 'errors#unprocessable'
  get '/406', to: 'errors#unacceptable'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
