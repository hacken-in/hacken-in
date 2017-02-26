Hcking::Application.routes.draw do
  devise_for :users, controllers: { sessions: "sessions", omniauth_callbacks: "callbacks" }

  ActiveAdmin.routes(self)
  namespace :admin do
    resources :events do
      resources :single_events
    end
  end

  namespace :api do
    resource :calendar, only: :none do
      get :entries
      get :selector
    end
  end

  resources :users, only: [:show] do
    resources :authorizations, only: [:destroy]
  end
  resources :suggestions, only: [:new, :create, :show]
  resources :events, only: [:index, :show] do
    resources :single_events, path: "dates", only: [:show] do
      resource :participate, only: [:update], constraints: { state: /(push|delete)/ }
    end
  end
  resource :calendar, only: [:show]
  resources :humans, only: [:index]
  resources :sitemap, only: [:index]
  resources :pages, only: [:show]
  resources :search, only: [:index]
  # Imagine a `resources :calendars` here, but it needs to be at the bottom of this file

  # Calendar Links
  get "export/ical/:region/all"           => "ical#general"
  get "export/ical/:region/mine/:guid"    => "ical#like_welcome_page"
  get "export/ical/:region/tag/:id"       => "ical#for_tag"
  get "export/ical/attending/:guid"       => "ical#personalized"
  get "export/ical/event/:id"             => "ical#for_event"
  get "export/ical/single_event/:id"      => "ical#for_single_event", as: "single_event_ical"
  get "export/ical"                       => "ical#everything"

  # Old, historic routes that need to be redirected
  get "ical",                    to: redirect("/export/ical/koeln/all")
  get "personalized_ical/:guid", to: redirect("/export/ical/koeln/mylikes/%{guid}")
  get "user_ical/:guid",         to: redirect("/export/ical/koeln/mine/%{guid}")
  get "single_event_ical/:id",   to: redirect("/export/ical/single_event/%{id}")
  get "event_ical/:id",          to: redirect("/export/ical/event/%{id}")
  get "tag_ical/:id",            to: redirect("/export/ical/koeln/tag/%{id}")
  get "deutschland",             to: redirect("/")
  get "move_to/:region",         to: redirect("/")
  get "impressum",               to: redirect("/pages/impressum")
  get ":region/search",          to: redirect("/")

  # This would be `resources :calendars`, but it has special requirements for the URL...
  get ":region" => "calendars#show", as: "region", :constraints => { :format => "html" }
  root to: "calendars#index"
end
