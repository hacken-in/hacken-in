Hcking::Application.routes.draw do
  devise_for :users

  resources :users, only: [:show] do
    resources :tags, controller: :user_tags, path: ":kind", constraints: { id: /.*/, kind: /(like|hate)/ }, only: [:create, :destroy]
  end

  match 'tags/:tagname'  => 'tags#show', constraints: { tagname: /.*/ }
  resources :tags, constraints: { id: /.*/ }, only: [:show, :index]

  resources :comments, only: [:index]

  resources :events do
    resources :comments, only: [:show, :create, :edit, :update, :destroy, :index]
    namespace "schedule" do
      resources :exdates, only: [:destroy]
      resources :rules, only: [:create, :destroy]
    end

    resources :single_events, path: "dates" do
      member do
        put :participate
        put :unparticipate
      end
      resources :comments, only: [:show, :create, :edit, :update, :destroy, :index]
    end

    # This is duplicate code, but the old routes with single_events must
    # keep on working
    resources :single_events do
      member do
        put :participate
        put :unparticipate
      end
      resources :comments, only: [:show, :create, :edit, :update, :destroy, :index]
    end
  end

  match 'ical' => "ical#general"
  match "personalized_ical/:guid" => "ical#personalized"
  match "user_ical/:guid" => "ical#like_welcome_page"
  match 'single_event_ical/:id' => 'ical#for_single_event'
  match 'event_ical/:id' => 'ical#for_event'
  match 'tag_ical/:id' => 'ical#for_tag'
  match 'abonnieren' => "subscribe#index"

  root to: 'welcome#index'

  match ':page_name' => 'pages#show'
end
