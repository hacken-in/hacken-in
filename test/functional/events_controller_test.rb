require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should get event" do
    event = FactoryGirl.create(:simple)
    get :show, id: event.id
    assert_response :success
  end

  test "should be showing list of events" do
    get :index
    assert_response :success
  end
end
