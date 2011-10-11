FactoryGirl.define do
  factory :simple, :class => 'event' do
    name "SimpleEvent"
  end

  factory :event_with_tags, :class => 'event' do
    name "Tagged Event"
    tag_list "ruby, rails"
  end
end

