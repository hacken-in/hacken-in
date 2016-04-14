FactoryGirl.define do
  factory :region_slug do
    sequence :slug do |n|
      "slug-#{n}"
    end
    association :region, factory: :slugless_region
  end
end
