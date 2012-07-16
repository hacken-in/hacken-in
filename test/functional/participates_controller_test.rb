require 'test_helper'

class ParticipatesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should create participate" do
    single_event = FactoryGirl.create(:single_event)
    user = FactoryGirl.create(:bodo)
    sign_in user

    post :create, single_event_id: single_event.id, event_id: single_event.event.id

    assert_equal user, single_event.users.first
    assert_redirected_to event_single_event_path(single_event.event, single_event)
  end

  test "should delete participate" do
    single_event = FactoryGirl.create(:single_event)
    user = FactoryGirl.create(:bodo)
    single_event.users << user
    sign_in user

    delete :destroy, single_event_id: single_event.id, event_id: single_event.event.id

    single_event.reload

    assert_equal 0, single_event.users.length
    assert_redirected_to event_single_event_path(single_event.event, single_event)
  end

  test "should not create participate if not logged in" do
    single_event = FactoryGirl.create(:single_event)
    user = FactoryGirl.create(:bodo)

    post :create, single_event_id: single_event.id, event_id: single_event.event.id

    assert_equal 0, single_event.users.length
    assert_not_nil flash[:error]
    assert_redirected_to event_single_event_path(single_event.event, single_event)
  end

  test "should not delete participate if not logged in" do
    single_event = FactoryGirl.create(:single_event)
    user = FactoryGirl.create(:bodo)
    single_event.users << user

    delete :destroy, single_event_id: single_event.id, event_id: single_event.event.id

    single_event.reload

    assert_equal 1, single_event.users.length
    assert_not_nil flash[:error]
    assert_redirected_to event_single_event_path(single_event.event, single_event)
  end

  test "should not create participate two times for the same event" do
    single_event = FactoryGirl.create(:single_event)
    user = FactoryGirl.create(:bodo)
    sign_in user

    post :create, single_event_id: single_event.id, event_id: single_event.event.id
    post :create, single_event_id: single_event.id, event_id: single_event.event.id

    assert_equal 1, single_event.users.length
    assert_redirected_to event_single_event_path(single_event.event, single_event)
  end

  test "should not delete participate if not participant of event" do
    single_event = FactoryGirl.create(:single_event)
    user = FactoryGirl.create(:bodo)

    delete :destroy, single_event_id: single_event.id, event_id: single_event.event.id

    single_event.reload

    assert_equal 0, single_event.users.length
    assert_not_nil flash[:error]
    assert_redirected_to event_single_event_path(single_event.event, single_event)
  end
end
