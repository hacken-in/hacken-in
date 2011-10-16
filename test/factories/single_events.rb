FactoryGirl.define do
  factory :single_event, :class => SingleEvent do
    topic "SimpleSingleEventTopic"
    association :event, :factory => :simple
  end

  factory :single_event_without_topic, :class => SingleEvent do
    association :event, :factory => :simple
  end

end
