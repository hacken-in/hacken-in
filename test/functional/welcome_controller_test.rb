require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  setup do
    post = FactoryGirl.create(:full_blog_post,
                              teaser_text: "Simple Headline Teaser",
                              headline: "SimpleBlogPost")
    FactoryGirl.create(:box, content: post)
  end

  test "should get index" do
    FactoryGirl.create(:full_blog_post)
    get :index
    assert_response :success
  end

  test "should find box with blog_post title & subtitle" do
    get :index
    assert_select '.article-title', "SimpleBlogPost"
    assert_select '.article-subtitle', "Simple Headline Teaser"
  end

  test "should find carousel with blog_post title & subtitle" do
    get :index
    assert_select '.carousel-caption h4', "SimpleBlogPost"
    assert_select '.carousel-caption p', "Simple Headline Teaser"
  end
end
