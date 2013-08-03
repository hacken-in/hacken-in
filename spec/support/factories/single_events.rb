FactoryGirl.define do
  factory :single_event, class: SingleEvent do
    name "SimpleSingleEventName"
    occurrence Time.new(2011,10,1,12,00)
    association :event, factory: :simple
    association :venue, factory: :cowoco_venue
    association :picture, factory: :picture
    based_on_rule true
  end

  factory :single_event_berlin, class: SingleEvent do
    name "SimpleSingleEventNameInHipsterCity"
    occurrence Time.new(2011,10,1,12,00)
    association :event, factory: :simple
    association :venue, factory: :berlin_venue
    association :picture, factory: :picture
    based_on_rule true
  end

  factory :extended_single_event, class: SingleEvent do
    name "SimpleSingleEventName"
    description "wow this is <strong>a</strong> description"
    occurrence Time.new(2011,10,1,12,00)
    association :event, factory: :full_event
    association :picture, factory: :picture
    based_on_rule true
  end

  factory :global_single_event, class: SingleEvent do
    name "SimpleGlobalSingleEventName"
    description "wow this is <strong>a</strong> description"
    occurrence Time.new(2011,10,1,12,00)
    association :event, factory: :global_event
    association :picture, factory: :picture
    based_on_rule true
  end

  factory :single_event_without_name, class: SingleEvent do
    association :event, factory: :simple
  end

  factory :single_event_without_rule, class: SingleEvent do
    name "SimpleSingleEventName"
    description "wow this is <strong>a</strong> description"
    occurrence Time.new(2011,10,1,12,00)
    association :event, factory: :full_event
    association :picture, factory: :picture
    based_on_rule false
  end

end
