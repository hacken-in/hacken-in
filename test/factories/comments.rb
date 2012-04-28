FactoryGirl.define do

  factory :single_event_comment, class: Comment do
    body "single event comment"
    commentable_type "SingleEvent"
    association :user, factory: :user
    association :commentable, factory: :single_event
  end

  factory :event_comment, class: Comment do
    body "event comment"
    commentable_type "Event"
    association :user, factory: :user
    association :commentable, factory: :simple
  end

end

