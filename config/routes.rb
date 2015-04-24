Hcking::Application.routes.draw do

  devise_for :users, controllers: { sessions: 'sessions', omniauth_callbacks: "callbacks" }

  devise_scope :users do
    get 'users', :to => 'users#show', :as => :user_root # Rails 3
  end

  ActiveAdmin.routes(self)

  namespace :admin do
    resources :events do
      resources :single_events
      resources :radar_settings
    end
  end

  namespace :api do
    resource :calendar, only: :none do
      get :entries
      get :selector
    end

    match "markdown_converter" => "markdown_converter#convert", via: [:get, :post]
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

  get "statistics"              => "statistics#index"
  get "statistics/:region"      => "statistics#show", as: "show_statistic"

  get "abonnieren"              => "subscribe#index"
  get "humans"                  => "humans#index"
  get "impressum"               => "pages#show", page_name: "impressum"
  get "sitemap.xml"             => "sitemap#show", format: "xml"

  # Calendar Links
  # These are the old links, without a region, redirect them to koeln
  get "ical",                    to: redirect('/export/ical/koeln/all')
  get "personalized_ical/:guid", to: redirect('/export/ical/koeln/mylikes/%{guid}')
  get "user_ical/:guid",         to: redirect('/export/ical/koeln/mine/%{guid}')
  get "single_event_ical/:id",   to: redirect('/export/ical/single_event/%{id}')
  get "event_ical/:id",          to: redirect('/export/ical/event/%{id}')
  get "tag_ical/:id",            to: redirect('/export/ical/koeln/tag/%{id}')

  # These are the new ones with a region in it
  get "export/ical/:region/all"           => "ical#general"
  get "export/ical/:region/mine/:guid"    => "ical#like_welcome_page"
  get "export/ical/:region/tag/:id"       => "ical#for_tag"
  get "export/ical/attending/:guid"       => "ical#personalized"
  get "export/ical/event/:id"             => "ical#for_event"
  get "export/ical/single_event/:id"      => "ical#for_single_event", as: "single_event_ical"
  get "export/ical"                       => "ical#everything"

  get "pages/:page_name"              => "pages#show"

  get "styleguide/(:reference)" => "styleguide#index", as: "styleguide"

  get "deutschland" => "welcome#deutschland", :constraints => { :format => 'html' }
  get "move_to/:region" => "welcome#move_to", as: "move_region"
  get ":region" => "calendars#show", as: "region", :constraints => { :format => 'html' }
  match ":region/search" => "search#index", as: "search", via: [:get, :post]


  root to: "welcome#index"
end
