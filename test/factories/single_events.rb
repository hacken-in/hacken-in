FactoryGirl.define do
  factory :single_event, :class => SingleEvent do
    topic "SimpleSingleEventTopic"
    occurrence Time.new(2011,10,1,12,00).localtime
    association :event, :factory => :simple
  end

  factory :single_event_without_topic, :class => SingleEvent do
    association :event, :factory => :simple
  end

end
