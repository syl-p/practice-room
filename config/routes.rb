Rails.application.routes.draw do
  resources :versions
  devise_for :users
  resources :media
  resources :exercises do 
    resources :comments, module: :exercises
    collection do
      get "me"
    end
  end

  resources :comments do 
    resources :comments, module: :comments
  end

  root "exercises#index"

  get "exercises/:id/edit/:step", to: "exercises#edit", as: "edit_exercise_with_step"
  get "exercises/new/:step", to: "exercises#new", as: "new_exercise_with_step"

  get "exercises/:id/versions", to: "exercises#get_versions_list", as: "list_versions"

  put "exercises/:id/favorites/add", to: "exercises#add_to_favorites"
  put "exercises/:id/favorites/remove", to: "exercises#remove_from_favorites"

  mount MediumUploader.download_endpoint => "/uploads"

  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
end
