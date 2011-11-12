# encoding: utf-8
FactoryGirl.define do
  factory :simple, :class => 'event' do
    name "SimpleEvent"
  end

  factory :full_event, :class => 'event' do
    name "SimpleEvent"
    location "CoWoCo, Gasmotorenfabrik, 3. Etage"
    street "Deutz-Mülheimerstraße 129"
    zipcode "51063"
    city "Köln"
    country "Germany"
    latitude 50.9491
    longitude 6.98682
  end

  factory :event_with_tags, :class => 'event' do
    name "Tagged Event"
    tag_list "ruby, rails"
  end
end

