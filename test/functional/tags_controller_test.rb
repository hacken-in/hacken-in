require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should get event tag list" do
    event = FactoryGirl.create(:event_with_tags)

    get :index, format: "js"
    assert_equal "[{\"name\":\"ruby\"},{\"name\":\"rails\"}]", @response.body

    get :index, format: "js", q: "rails"
    assert_equal "[{\"name\":\"rails\"}]", @response.body

    get :index, format: "js", q: "keintagvorhanden"
    assert_equal "[]", @response.body
 end
 
 test "search for specific tags" do
   event = FactoryGirl.create(:event_with_tags)
   
   get :show, tagname: 'none'
   assert_response :success
   
   get :show, tagname: 'ruby'
   assert_response :success

   # We look for an anchor to the ruby tag, which should be found.
   assert @response.body =~ /ruby<\/a>/
 end
 
end
