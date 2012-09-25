# encoding: utf-8
FactoryGirl.define do
  factory :venue, class: 'venue' do 
    location "CoWoCo, Gasmotorenfabrik, 3. Etage"
    street "Deutz-Mülheimerstraße 129"
    zipcode "51063"
    city "Köln"
    latitude 50.9490279
    longitude 6.986784900000001
  end
end