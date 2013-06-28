# encoding: utf-8
FactoryGirl.define do
  factory :global_region, class: 'region' do
    name { Faker::Address.city }
    slug { Faker::Internet.domain_word }
  end

  factory :koeln_region, class: 'region' do
    name { Faker::Address.city }
    slug { Faker::Internet.domain_word }
  end

  factory :berlin_region, class: 'region' do
    name { Faker::Address.city }
    slug { Faker::Internet.domain_word }
  end
end

