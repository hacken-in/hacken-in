Hcking::Application.routes.draw do
  devise_for :users
  
  match 'tags/:tagname'  => 'tags#show'
  resources :tags
  
  resources :events do
    namespace "schedule" do
      resources :rdates, :exdates, :rules

      match 'update' => 'update#update', :via => :put
    end
  end
  match 'ical' => "ical#index"

  root :to => 'welcome#index'

  match ':page_name' => 'pages#show'
  

end
