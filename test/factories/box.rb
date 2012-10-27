FactoryGirl.define do
  factory :box, class: Box do
    association :content, factory: :full_blog_post
    position 1
  end
end
