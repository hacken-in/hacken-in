require 'test_helper'

class ParticipatesControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def assert_response_for single_event, format
    assert_template ["single_events/_participants", "participates/update"] if format == :js
    assert_redirected_to event_single_event_path(single_event.event, single_event) if format == :html
  end

  [:html, :js].each do |format|
    test "should create participate with format #{format}" do
      single_event = FactoryGirl.create(:single_event)
      user = FactoryGirl.create(:bodo)
      sign_in user

      post :update, single_event_id: single_event.id, event_id: single_event.event.id, format: format, state: :push

      assert_equal user, single_event.users.first
      assert_response_for single_event, format
    end

    test "should delete participate with format #{format}" do
      single_event = FactoryGirl.create(:single_event)
      user = FactoryGirl.create(:bodo)
      single_event.users << user
      sign_in user

      post :update, single_event_id: single_event.id, event_id: single_event.event.id, format: format, state: :delete

      single_event.reload

      assert_equal 0, single_event.users.length
      assert_response_for single_event, format
    end

    test "should not create participate if not logged in with format #{format}" do
      single_event = FactoryGirl.create(:single_event)
      user = FactoryGirl.create(:bodo)

      post :update, single_event_id: single_event.id, event_id: single_event.event.id, format: format, state: :push

      assert_equal 0, single_event.users.length
      assert_not_nil flash[:error]
      assert_response_for single_event, format
    end

    test "should not delete participate if not logged in with format #{format}" do
      single_event = FactoryGirl.create(:single_event)
      user = FactoryGirl.create(:bodo)
      single_event.users << user

      post :update, single_event_id: single_event.id, event_id: single_event.event.id, format: format, state: :delete

      single_event.reload

      assert_equal 1, single_event.users.length
      assert_not_nil flash[:error]
      assert_response_for single_event, format
    end

    test "should not create participate two times for the same event with format #{format}" do
      single_event = FactoryGirl.create(:single_event)
      user = FactoryGirl.create(:bodo)
      sign_in user

      post :update, single_event_id: single_event.id, event_id: single_event.event.id, format: format, state: :push
      post :update, single_event_id: single_event.id, event_id: single_event.event.id, format: format, state: :push

      assert_equal 1, single_event.users.length
      assert_response_for single_event, format
    end

    test "should not delete participate if not participant of event with format #{format}" do
      single_event = FactoryGirl.create(:single_event)
      user = FactoryGirl.create(:bodo)

      post :update, single_event_id: single_event.id, event_id: single_event.event.id, format: format, state: :delete

      single_event.reload

      assert_equal 0, single_event.users.length
      assert_not_nil flash[:error]
      assert_response_for single_event, format
    end
  end
end
