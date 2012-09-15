require 'test_helper'

class SearchControllerTest < ActionController::TestCase
include Devise::TestHelpers

  test "should get index" do
  	sign_in FactoryGirl.create(:user)
    get :index
    assert_response :success
  end

  test "should find single event with string 'Simple'" do
    single_event = FactoryGirl.create(:single_event)
    get :index, search: "Simple"
    assert_select 'ul.result li', "SimpleSingleEventName - SimpleEvent"
  end

  test "should find event with string 'Event'" do
    event = FactoryGirl.create(:simple)
    get :index, search: "Event"
  	assert_select 'ul.result li', "SimpleEvent"
  end

  test "should find blog_post with string 'Headline'" do
    sign_in FactoryGirl.create(:bodo)
    event = FactoryGirl.create(:full_blog_post)
    get :index, search: "Headline"
  	assert_select 'ul.result li', "SimpleBlogPost"
  end


end
