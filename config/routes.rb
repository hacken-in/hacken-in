Hcking::Application.routes.draw do

  devise_for :users, controllers: { omniauth_callbacks: "callbacks" }

  devise_scope :users do
    get 'users', :to => 'users#show', :as => :user_root # Rails 3
  end

  ActiveAdmin.routes(self)

  namespace :admin do
    resources :events do
      resources :single_events
    end
  end

  namespace :api do
    resource :calendar, only: [:show] do
      get :presets
      get :entries

      post :presets, :action => :update_presets
    end

    resources :user_tags, :path => "/user/:kind", :constraints => { id: /.*/, kind: /(like|hate)/ }, :only => [:create, :destroy]
    match "markdown_converter" => "markdown_converter#convert"
  end

  resources :users, only: [:show] do
    resources :authorizations, only: [:destroy]
  end

  resources :search, only: [:index]
  resources :comments, only: [:create, :edit, :show]
  resources :suggestions, only: [:new, :create, :show]
  resource :calendar, only: [:show]

  resources :events, only: [:index, :show] do
    resources :comments, except: [:new]

    resources :single_events, path: "dates", only: [:show] do
      resource :participate, only: [:update], constraints: { state: /(push|delete)/ }
      resources :comments, except: [:new]
    end
  end

  match "koeln"                   => "calendars#show"
  match "ical"                    => "ical#general"
  match "personalized_ical/:guid" => "ical#personalized"
  match "user_ical/:guid"         => "ical#like_welcome_page"
  match "single_event_ical/:id"   => "ical#for_single_event", as: "single_event_ical"
  match "event_ical/:id"          => "ical#for_event"
  match "tag_ical/:id"            => "ical#for_tag"
  match "abonnieren"              => "subscribe#index"
  match "humans"                  => "humans#index"
  match "impressum"               => "pages#show", page_name: "impressum"

  match ":page_name"              => "pages#show"

  root to: redirect { |p, req| req.flash.keep; "/koeln" }
end
