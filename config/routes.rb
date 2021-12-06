Rails.application.routes.draw do
  resources :categories
  get 'users/index'
  get 'users/show'
  # resources :versions
  devise_for :users
  resources :media
  resources :exercises do
    resources :comments, module: :exercises
    collection do
      get "me"
      get ":id/edit/:step", to: "exercises#edit", as: "edit_with_step"
      get "new/:step", to: "exercises#new", as: "new_with_step"

      get ":id/practice/add", to: "exercises#add_to_practice", as: "add_to_practice"
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

  # Here because use turbo ??
  get "exercises/:id/versions", to: "exercises#get_versions_list", as: "list_versions"
  delete "exercises/:index/practice/remove/:sessions_of_the_day_id/:session_index", to: "exercises#remove_from_practice", as: "remove_from_practice"

  get "sessons_of_the_days/previous(/:id)", to: "sessions_of_the_days#get_previous", as: "previous_session"
  get "sessons_of_the_days/next(/:id)", to: "sessions_of_the_days#get_next", as: "next_session"

  mount MediumUploader.download_endpoint => "/uploads"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
