FactoryGirl.define do
  factory :single_event, :class => SingleEvent do
    topic "SimpleSingleEventTopic"
    occurrence Time.new(2011,10,1,12,00)
    association :event, :factory => :simple
  end

  factory :extended_single_event, :class => SingleEvent do
    topic "SimpleSingleEventTopic"
    occurrence Time.new(2011,10,1,12,00)
    association :event, :factory => :full_event
  end

  factory :single_event_without_topic, :class => SingleEvent do
    association :event, :factory => :simple
  end

end
