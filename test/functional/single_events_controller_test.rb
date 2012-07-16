# encoding: utf-8

require 'test_helper'

class SingleEventsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should be successful" do
    single_event = FactoryGirl.create(:single_event)
    get :show, id: single_event.id, event_id: single_event.event.id
    assert_response :success
  end

  test "should be successful as user" do
    single_event = FactoryGirl.create(:single_event)
    user = FactoryGirl.create(:bodo)
    sign_in user

    get :show, id: single_event.id, event_id: single_event.event.id
    assert_response :success
  end

  test "should be successful as participated user" do
    single_event = FactoryGirl.create(:single_event)
    user = FactoryGirl.create(:bodo)
    single_event.users << user
    sign_in user

    get :show, id: single_event.id, event_id: single_event.event.id
    assert_response :success
  end

  test "should render the comments partial in order to show and post comments" do
    single_event = FactoryGirl.create(:single_event)
    get :show, id: single_event.id, event_id: single_event.event.id
    assert_template("_comments")
  end

  test "should be able to edit if logged in" do
    single_event = FactoryGirl.create(:single_event)
    sign_in FactoryGirl.create(:user)
    get :edit, id: single_event.id, event_id: single_event.event.id

    assert_response :success

    put :update, id: single_event.id, event_id: single_event.event.id, single_event: {topic: "Something new"}
    single_event.reload
    assert_match /Something new.+/, single_event.name
  end

  test "should not delete if not bodo" do
    single_event = FactoryGirl.create(:single_event)
    assert_no_difference 'SingleEvent.count' do
      put :destroy, id: single_event.id, event_id: single_event.event.id
    end
    assert_redirected_to controller: 'welcome', action: 'index'
  end

  test "should delete single event and create reoccurence rule if created by rule" do
    single_event = FactoryGirl.create(:single_event)
    event = single_event.event
    user = FactoryGirl.create(:bodo)
    sign_in user
    assert_difference 'SingleEvent.count', -1 do
      put :destroy, id: single_event.id, event_id: single_event.event.id
    end
    event = Event.find(event.id)
    assert_equal 1, event.schedule.extimes.count
  end

  test "should delete single event and do not create reoccurence rule" do
    single_event = FactoryGirl.create(:single_event)
    single_event.based_on_rule = false
    single_event.save
    event = single_event.event
    user = FactoryGirl.create(:bodo)
    sign_in user
    assert_difference 'SingleEvent.count', -1 do
      put :destroy, id: single_event.id, event_id: single_event.event.id
    end
    event = Event.find(event.id)
    assert_equal 0, event.schedule.extimes.count
  end

  test "should create new single event" do
    event = FactoryGirl.create(:simple)
    sign_in FactoryGirl.create(:bodo)
    get :new, event_id: event.id
    assert_response :success

    assert_difference('SingleEvent.count') do
      put :create, event_id: event.id, single_event: { topic: "Hallo" }
    end
    assert_equal "Hallo", assigns(:single_event).topic
    assert_redirected_to event_path(assigns(:event))
  end

end
