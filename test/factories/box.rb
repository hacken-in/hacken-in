FactoryGirl.define do
  factory :box, class: Box do
    association :content, factory: :full_blog_post
    grid_position 1
  end
end
