FactoryGirl.define do
  factory :radar_setting do
    association :event, factory: :event
  end
end
