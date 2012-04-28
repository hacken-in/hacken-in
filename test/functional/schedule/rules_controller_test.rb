require 'test_helper'

class Schedule::RulesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should not create new rule if not bodo" do
    event = FactoryGirl.create(:simple)

    put :create, event_id: event.id, day_of_week: 1, week_number: 1
    assert_not_nil flash.alert
    assert_redirected_to root_path

    sign_in FactoryGirl.create(:user)
    put :create, event_id: event.id, day_of_week: 1, week_number: 1
    assert_not_nil flash.alert
    assert_redirected_to root_path
  end

  test "should not delete new rule if not bodo" do
    event = FactoryGirl.create(:simple)

    delete :destroy, event_id: event.id, id: 0
    assert_not_nil flash.alert
    assert_redirected_to root_path

    sign_in FactoryGirl.create(:user)
    delete :destroy, event_id: event.id, id: 0
    assert_not_nil flash.alert
    assert_redirected_to root_path
  end

  test "should create and delete new rule if bodo" do
    event = FactoryGirl.create(:simple)

    sign_in FactoryGirl.create(:bodo)
    put :create, event_id: event.id, day_of_week: 1, week_number: 1
    assert_not_nil flash.notice
    assert_redirected_to event_path(event)
    event = Event.find(event.id)
    assert_equal 1, event.schedule.rrules.count
    assert_equal "Monthly on the 1st Monday", event.schedule.rrules.first.to_s

    delete :destroy, event_id: event.id, id: 0
    assert_not_nil flash.notice
    assert_redirected_to event_path(event)
    event = Event.find(event.id)
    assert_equal 0, event.schedule.rrules.count
  end

end
