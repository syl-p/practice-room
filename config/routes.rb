Rails.application.routes.draw do
  devise_for :users, :controllers => { :registrations => "registrations" }
  resources :categories do
    collection do
      get "new", to: "categories#new", as: "new"
      get ":slug", to: "categories#get_by_slug", as: "by_slug"
    end
  end

  get 'users/show'
  get 'dashboard', to: "users#index", as: "dashboard"

  resources :media do
    collection do
      get 'me'
    end
  end

  resources :exercises do
    resources :comments, module: :exercises
    collection do
      post "search"
      get "me"
      get ":id/edit/:step", to: "exercises#edit", as: "edit_with_step"
      get "new/:step", to: "exercises#new", as: "new_with_step"
      get ":id/versions", to: "exercises#versions", as: "versions_list"
      # route for stimulus actions
      get ":id/practice/add(/:time)", to: "practices#add_to_practice", defaults: { format: :turbo_stream }, as: "add_to_practice"
      get ":id/favorites/:add_or_remove", to: "exercises#add_or_remove_favorite", defaults: { format: :turbo_stream }, as: "add_or_remove_favorite"

      # route for turbo frame query
      get "list"

    end
  end

  resources :comments do
    resources :comments, module: :comments
  end

  root "exercises#index"

  get "users/:id", to: "users#show", as: "user"
  delete "users/:id/delete_avatar", to: "users#delete_avatar", as: "delete_avatar"


  delete "practice/remove/:practices_exercises_id", to: "practices#remove_from_practice", as: "remove_from_practice"

  # Date selector for practice list
  get "practices/:previous_next/:date", to: "practices#get_week", as: "get_week"
  get "practices/:date", to: "practices#get_day", defaults: { format: :turbo_stream }, as: "get_day"

  # Here because use turbo ??
  get "exercises/:id/versions", to: "exercises#get_versions_list", as: "list_versions"

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
