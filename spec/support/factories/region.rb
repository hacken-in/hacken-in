# encoding: utf-8
FactoryGirl.define do
  factory :global_region, class: 'region' do
    id 1
    name "global"
    after(:create) do |region, _evaluator|
      RegionSlug.where(slug: 'global', region: region).first_or_create!
    end
  end

  factory :koeln_region, class: 'region' do
    id 2
    name "Köln"
    after(:create) do |region, _evaluator|
      RegionSlug.where(slug: 'koeln', region: region).first_or_create!
    end
  end

  factory :berlin_region, class: 'region' do
    id 3
    name "Berlin"
    after(:create) do |region, _evaluator|
      RegionSlug.where(slug: 'berlin', region: region).first_or_create!
    end
  end

  factory :slugless_region, class: 'region' do
    id 4
    name "Region"
  end
end

