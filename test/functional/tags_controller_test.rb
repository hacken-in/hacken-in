require 'test_helper'

class TagsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should get event tag list" do
    event = Factory(:event_with_tags)

    get :index, :format => "js"
    assert_equal "[{\"name\":\"ruby\"},{\"name\":\"rails\"}]", @response.body

    get :index, :format => "js", :q => "rails"
    assert_equal "[{\"name\":\"rails\"}]", @response.body

    get :index, :format => "js", :q => "keintagvorhanden"
    assert_equal "[]", @response.body
 end
end
