require 'test_helper'

class EventsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should redirect to calendar if there are no single events" do
    event = FactoryGirl.create(:simple)
    get :show, id: event.id
    assert_redirected_to :calendar
  end

  test "should redirect to the best fitting single event" do
    event = FactoryGirl.create(:simple)
    single_event = FactoryGirl.create(:single_event, event: event)

    Event.expects(:find).with(event.id.to_s).returns(event)
    event.expects(:closest_single_event).with(Date.new).returns(single_event)

    get :show, id: event.id
    assert_redirected_to event_single_event_path(event, single_event)
  end

  test "should redirect to calender page" do
    get :index
    assert_redirected_to :calendar
  end
end
