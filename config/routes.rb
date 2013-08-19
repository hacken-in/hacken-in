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
      get :entries
    end

    resources :user_tags, :path => "/user/:kind", :constraints => { id: /.*/, kind: /(like|hate)/ }, :only => [:create, :destroy]
    match "markdown_converter" => "markdown_converter#convert"
  end

  resources :users, only: [:show] do
    resources :authorizations, only: [:destroy]
  end

  resources :comments, only: [:create, :edit, :update]
  resources :suggestions, only: [:new, :create, :show]
  resource :calendar, only: [:show]

  resources :events, only: [:index, :show] do
    resources :comments, except: [:new]

    resources :single_events, path: "dates", only: [:show] do
      resource :participate, only: [:update], constraints: { state: /(push|delete)/ }
      resources :comments, except: [:new]
    end
  end

  match "abonnieren"              => "subscribe#index"
  match "humans"                  => "humans#index"
  match "impressum"               => "pages#show", page_name: "impressum"

  # Calendar Links
  # These are the old links, without a region, redirect them to koeln
  match "ical",                    to: redirect('/export/ical/koeln/all')
  match "personalized_ical/:guid", to: redirect('/export/ical/koeln/mylikes/%{guid}')
  match "user_ical/:guid",         to: redirect('/export/ical/koeln/mine/%{guid}')
  match "single_event_ical/:id",   to: redirect('/export/ical/single_event/%{id}')
  match "event_ical/:id",          to: redirect('/export/ical/event/%{id}')
  match "tag_ical/:id",            to: redirect('/export/ical/koeln/tag/%{id}')

  # These are the new ones with a region in it
  match "export/ical/:region/all"           => "ical#general"
  match "export/ical/:region/mine/:guid"    => "ical#like_welcome_page"
  match "export/ical/:region/tag/:id"       => "ical#for_tag"
  match "export/ical/attending/:guid"       => "ical#personalized"
  match "export/ical/event/:id"             => "ical#for_event"
  match "export/ical/single_event/:id"      => "ical#for_single_event", as: "single_event_ical"
  match "export/ical"                       => "ical#everything"

  match "pages/:page_name"              => "pages#show"

  match "deutschland" => "welcome#deutschland"
  match "move_to/:region" => "welcome#move_to", as: "move_region"
  match ":region" => "calendars#show", as: "region"
  match ":region/search" => "search#index", as: "search"

  root to: "welcome#index"
end
