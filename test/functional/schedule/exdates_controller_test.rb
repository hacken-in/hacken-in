require 'test_helper'

class Schedule::ExdatesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should not delete new exdate if not bodo" do
    event = FactoryGirl.create(:simple)

    delete :destroy, :event_id => event.id, :id => 0
    assert_not_nil flash.alert
    assert_redirected_to root_path

    sign_in FactoryGirl.create(:user)
    delete :destroy, :event_id => event.id, :id => 0
    assert_not_nil flash.alert
    assert_redirected_to root_path
  end

  test "should create and delete new exdate if bodo" do
    event = FactoryGirl.create(:simple)

    sign_in FactoryGirl.create(:bodo)
    event = Event.find(event.id)
    event.schedule.add_exception_time Time.new(1980,5,1,12,30)

    delete :destroy, :event_id => event.id, :id => 0
    assert_not_nil flash.notice
    assert_redirected_to event_path(event)
    event = Event.find(event.id)
    assert_equal 0, event.schedule.extimes.count
  end

end
