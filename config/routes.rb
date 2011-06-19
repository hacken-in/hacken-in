Hcking::Application.routes.draw do
  devise_for :users

  resources :events
  match 'ical' => "ical#index"

  root :to => 'welcome#index'

  match ':page_name' => 'pages#show'
end
