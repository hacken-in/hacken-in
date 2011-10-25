# encoding: utf-8

require 'test_helper'

class SingleEventsControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should be successful" do
    single_event = FactoryGirl.create(:single_event)
    get :show, :id => single_event.id, :event_id => single_event.event.id
    assert_response :success
  end

  test "should render the comments partial in order to show and post comments" do
    single_event = FactoryGirl.create(:single_event)
    get :show, :id => single_event.id, :event_id => single_event.event.id
    assert_template("_comments")
  end

  test "should not be able to edit if not bodo" do
    single_event = FactoryGirl.create(:single_event)
    sign_in FactoryGirl.create(:user)
    get :edit, :id => single_event.id, :event_id => single_event.event.id

    assert_redirected_to :controller => 'welcome', :action => 'index'
  end

  test "should be able to edit if bodo" do
    single_event = FactoryGirl.create(:single_event)
    sign_in FactoryGirl.create(:bodo)
    get :edit, :id => single_event.id, :event_id => single_event.event.id

    assert_response :success

    put :update, :id => single_event.id, :event_id => single_event.event.id, :single_event => {:topic => "Something new"}
    single_event.reload
    assert_match /Something new.+/, single_event.name
  end
end
