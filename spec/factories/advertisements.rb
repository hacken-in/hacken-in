FactoryGirl.define do
  factory :advertisement, class: Advertisement do
    calendar_week Time.now.iso_cweek
    description "This is the best box ever"
    duration 2
    link "http://nerdhub.de"
    context "homepage"
    association :picture, factory: :picture
  end
end
