TestDk::Application.routes.draw do

  get 'assisters/index'

  get 'assisters/new'

  get 'assisters/new_two'

  get 'assisters/new_last'

  get 'assisters/show'

  get 'assisters/create'

  get 'visitors/index'

  get 'visitors/show'

  get 'visitors/new'

  get 'visitors/create'

  # I like having this to populate the navbar with, via the database rather than do it in the views.
  resources :navbar_entries

  get '/page/:page_id' => 'pages#show'
  post '/page/:page_id' => 'pages#show'
  
  # Logins and Profiles
  devise_for :users, controllers: { sessions: "users/sessions" }
  resource :profile

  resources :plans

  # Goodrx
  get '/drug_search' => 'drugs#search'

  # Pokitdok
  get '/procedures_search' => 'procedures#search_form'
  post '/procedures_search' => 'procedures#search'
  
  root to: 'pages#show_home'

  # The rest of the routes file is probably useless to most new apps based on this template, EXCEPT for the 
  # 404 catchall below which has to always be at the end.

  # Adds RailsAdmin
  mount RailsAdmin::Engine => '/rails_admin', as: 'rails_admin'

  # Added API and Doorkeeper
  constraints(format: /json/) do
    namespace :api, defaults: {format: 'json'} do
      namespace :v1 do
        post '/users/:action' => 'users#api_action'
        get '/procedures/:action' => 'procedures#api_action'
        post '/drugs/:action' => 'drugs#api_action'
      end
    end
  end


  # Need a catch all to redirect to the errors controller, for catching 404s as an exception
  match "*path", to: "errors#catch_404", via: [:get, :post]

end
