FactoryGirl.define do
  factory :radar_entry do
    association :radar_setting, factory: :radar_setting
  end
end
