# encoding: utf-8
FactoryGirl.define do
  factory :full_blog_post, class: 'blog_post' do
    headline "SimpleBlogPost"
    headline_teaser "Simple Headline Teaser"
    teaser_text "Teaser Text"
    text "Free Text"
    association :picture, factory: :picture
    association :user, factory: :user
    association :category, factory: :a_category
  end
end
