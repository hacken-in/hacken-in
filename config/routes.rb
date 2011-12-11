Hcking::Application.routes.draw do
  devise_for :users

  resources :users, :only => [:show] do
    resources :hate_tags, controller: :user_hate_tags, :constraints => { :id => /.*/ }, :only => [:create, :destroy]
  end

  match 'tags/:tagname'  => 'tags#show', :constraints => { :tagname => /.*/ }
  resources :tags, :constraints => { :id => /.*/ }, :only => [:show, :index]

  resources :comments, :only => [:index]

  resources :events do
    resources :comments, :only => [:show, :create, :edit, :update, :destroy, :index]
    namespace "schedule" do
      resources :rdates, :only => [:create, :destroy]
      resources :exdates, :only => [:create, :destroy]
      resources :rules, :only => [:create, :destroy]

      match 'update' => 'update#update', :via => :put
    end
    resources :single_events, :only => [:show, :update, :edit] do
      member do
        put :participate
        put :unparticipate
      end
      resources :comments, :only => [:show, :create, :edit, :update, :destroy, :index]
    end
  end

  match 'ical' => "ical#general"
  match "personalized_ical/:guid" => "ical#personalized"
  match 'abonnieren' => "welcome#abonnieren"

  root :to => 'welcome#index'

  match ':page_name' => 'pages#show'
end
