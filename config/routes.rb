Hcking::Application.routes.draw do
  devise_for :users

  resources :events
  match 'ical' => "events#ical"

  root :to => 'welcome#index'

  match ':page_name' => 'pages#show'
end
