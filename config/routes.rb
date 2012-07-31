Hcking::Application.routes.draw do
  devise_for :users, controllers: { omniauth_callbacks: "callbacks" }
  
  devise_for :admin_users, ActiveAdmin::Devise.config
  ActiveAdmin.routes(self)
  
  resources :users, only: [:show] do
    resources :tags,
      controller: :user_tags,
      path: ":kind",
      constraints: { id: /.*/, kind: /(like|hate)/ },
      only: [:create, :destroy]
  end


  match "tags/:tagname"  => "tags#show", constraints: { tagname: /.*/ }
  resources :tags, constraints: { id: /.*/ }, only: [:show, :index]

  resources :comments, only: [:index]

  resources :events do
    resources :comments, except: [:new]
    namespace "schedule" do
      resources :exdates, only: [:destroy]
      resources :rules, only: [:create, :destroy]
    end

    resources :single_events, path: "dates" do
      resource :participate, only: [:update], constraints: { state: /(push|delete)/ }
      resources :comments, except: [:new]
    end
    # to hold old url on life
    get "single_events/:id" => redirect { |params, request| "/events/#{params[:event_id]}/dates/#{params[:id]}" }
  end

  match "ical"                    => "ical#general"
  match "personalized_ical/:guid" => "ical#personalized"
  match "user_ical/:guid"         => "ical#like_welcome_page"
  match "single_event_ical/:id"   => "ical#for_single_event"
  match "event_ical/:id"          => "ical#for_event"
  match "tag_ical/:id"            => "ical#for_tag"
  match "abonnieren"              => "subscribe#index"
  match ":page_name"              => "pages#show"

  root to: "welcome#index"
  
end
