FactoryGirl.define do
  factory :single_event do
    topic "SimpleSingleEventTopic"
    association :event, :factory => :simple
  end
end
