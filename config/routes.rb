Hcking::Application.routes.draw do
  devise_for :users

  resources :users do
    resources :hate_tags, controller: :user_hate_tags, :constraints => { :id => /.*/ }
  end

  match 'tags/:tagname'  => 'tags#show', :constraints => { :tagname => /.*/ }
  resources :tags, :constraints => { :id => /.*/ }

  resources :comments, :only => [:index]

  resources :events do
    resources :comments
    namespace "schedule" do
      resources :rdates, :exdates, :rules

      match 'update' => 'update#update', :via => :put
    end
    resources :single_events, :only => [:show, :update, :edit] do
      member do
        put :participate
        put :unparticipate
      end
      resources :comments
    end
  end

  match 'ical' => "ical#general"
  match "personalized_ical/:guid" => "ical#personalized"
  match 'abonnieren' => "welcome#abonnieren"

  root :to => 'welcome#index'

  match ':page_name' => 'pages#show'

end
