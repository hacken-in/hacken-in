# encoding: utf-8
FactoryGirl.define do
  factory :global_region, class: 'region' do
    id 1
    name "global"
    slug "global"
  end

  factory :koeln_region, class: 'region' do
    id 2
    name "Köln"
    slug "koeln"
  end

  factory :berlin_region, class: 'region' do
    id 3
    name "Berlin"
    slug "berlin"
  end
end

