Rails.application.routes.draw do
  get 'users/index'
  get 'users/show'
  resources :versions
  devise_for :users
  resources :media
  resources :exercises do 
    resources :comments, module: :exercises
    collection do
      get "me"
      get ":id/edit/:step", to: "exercises#edit", as: "edit_exercise_with_step"
      get "new/:step", to: "exercises#new", as: "new_exercise_with_step"
      get ":id/versions", to: "exercises#get_versions_list", as: "list_versions"
      get ":exercise_id/add_to_practice", to: "exercises#add_to_practice", as: "add_to_practice"

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

  mount MediumUploader.download_endpoint => "/uploads"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
