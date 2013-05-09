# encoding: utf-8
FactoryGirl.define do
  factory :global_region, class: 'region' do
    name 'Global'
    slug 'global'
  end

  factory :koeln_region, class: 'region' do
    name 'Köln'
    slug 'koeln'
  end
end

