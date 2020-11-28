Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  root "works#root"

  # omniauth login route
  get "/auth/github", as: "github_login"

  # omniauth github callback
  get "/auth/:provider/callback", to: "users#create", as: "auth_callback"

  # get "/login", to: "users#login_form", as: "login"
  # post "/login", to: "users#login"
  delete "/logout", to: "users#destroy", as: "logout"
  # post "/logout", to: "users#logout", as: "logout"

  resources :works
  post "/works/:id/upvote", to: "works#upvote", as: "upvote"

  resources :users, only: [:index, :show]
end
