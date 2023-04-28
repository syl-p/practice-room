Rails.application.routes.draw do
  get 'goal_settings/new'
  get 'goal_settings/create'
  get 'goal_settings/update'
  get 'goal_settings/edit'
  get 'goal_settings/destroy'
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
    resources :goal_settings, module: :exercises
    collection do
      post "search", defaults: { format: :turbo_stream }
      get "search", defaults: { format: :turbo_stream }
      get "me"
      get ":id/edit/:step", to: "exercises#edit", as: "edit_with_step"
      get "new/:step", to: "exercises#new", as: "new_with_step"
      get ":id/versions", to: "exercises#versions", as: "versions_list"
      # route for stimulus actions
      get ":id/practice/add(/:time)", to: "practices#add_to_practice", defaults: { format: :turbo_stream }, as: "add_to_practice"
      get ":id/favorites/:add_or_remove", to: "exercises#add_or_remove_favorite", defaults: { format: :turbo_stream }, as: "add_or_remove_favorite"
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

  # Pages
  get "/pages/:slug", to: "pages#show", as: "page"

  # Follows
  delete "unfollow/:id", to: "follows#destroy", as: "unfollow"
  post "follow/:id", to: "follows#create", as: "follow"

  # Errors routes
  get '/404', to: 'errors#not_found'
  get '/500', to: 'errors#internal_server'
  get '/422', to: 'errors#unprocessable'
  get '/406', to: 'errors#unacceptable'

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
