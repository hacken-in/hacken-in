require 'test_helper'

class WelcomeControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  test "should get index" do
    FactoryGirl.create(:full_blog_post)
    FactoryGirl.create(:welcome_content)
    get :index
    assert_response :success
  end

  test "should find box with blog_post title & subtitle" do
    sign_in FactoryGirl.create(:bodo)
    FactoryGirl.create(:full_blog_post)
    FactoryGirl.create(:welcome_content)
    get :index
  	assert_select '.article-title', "SimpleBlogPost"
  	assert_select '.article-subtitle', "Simple Headline Teaser"
  end

  test "should find carousel with blog_post title & subtitle" do
  	sign_in FactoryGirl.create(:bodo)
    FactoryGirl.create(:full_blog_post)
    FactoryGirl.create(:welcome_content)
    get :index
  	assert_select '.carousel-caption h4', "SimpleBlogPost"
  	assert_select '.carousel-caption p', "Simple Headline Teaser"
  end

  # test "should find carousel with picture" do
  # 	sign_in FactoryGirl.create(:bodo)
  #   event = FactoryGirl.create(:full_blog_post)
  #   picture = FactoryGirl.create(:picture)
  #   welcome_content = FactoryGirl.create(:welcome_content)
  #   get :index
  #   assert_select '.carousel-inner div img', "test-werbung.png"
  # end

  # test "should find box with picture title" do
  # 	sign_in FactoryGirl.create(:bodo)
  #   event = FactoryGirl.create(:full_blog_post)
  #   picture = FactoryGirl.create(:picture)
  #   welcome_content = FactoryGirl.create(:welcome_content)
  #   get :index
  #   assert_select 'article img', "some title"
  # end

end
