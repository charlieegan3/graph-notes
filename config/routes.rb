Rails.application.routes.draw do
  root "notes#index"

  get "search", to: "notes#search"

  resources :notes
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
