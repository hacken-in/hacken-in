# encoding: utf-8

require 'test_helper'

class SingleEventsControllerTest < ActionController::TestCase
  include Devise::TestHelpers
  setup do
    FactoryGirl.create :advertisement, context: "single_event"
  end

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
end
