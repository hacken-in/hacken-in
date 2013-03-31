require 'spec_helper'

def assert_response_for single_event, format
  assert_template ["single_events/_participants", "participates/update"] if format == :js
  assert_redirected_to event_single_event_path(single_event.event, single_event) if format == :html
end

describe ParticipatesController do
  include Devise::TestHelpers

  [:html, :js].each do |format|
    it "should create participate with format #{format}" do
      single_event = FactoryGirl.create(:single_event)
      user = FactoryGirl.create(:bodo)
      sign_in user

      post :update, single_event_id: single_event.id, event_id: single_event.event.id, format: format, state: :push

      single_event.users.first.should == user
      assert_response_for single_event, format
    end

    it "should delete participate with format #{format}" do
      single_event = FactoryGirl.create(:single_event)
      user = FactoryGirl.create(:bodo)
      single_event.users << user
      sign_in user

      post :update, single_event_id: single_event.id, event_id: single_event.event.id, format: format, state: :delete

      single_event.reload

      single_event.users.length.should == 0
      assert_response_for single_event, format
    end

    it "should not create participate if not logged in with format #{format}" do
      single_event = FactoryGirl.create(:single_event)
      FactoryGirl.create(:bodo)

      post :update, single_event_id: single_event.id, event_id: single_event.event.id, format: format, state: :push

      single_event.users.length.should == 0
      flash[:error].should_not be_nil
      assert_response_for single_event, format
    end

    it "should not delete participate if not logged in with format #{format}" do
      single_event = FactoryGirl.create(:single_event)
      user = FactoryGirl.create(:bodo)
      single_event.users << user

      post :update, single_event_id: single_event.id, event_id: single_event.event.id, format: format, state: :delete

      single_event.reload

      single_event.users.length.should == 1
      flash[:error].should_not be_nil
      assert_response_for single_event, format
    end

    it "should not create participate two times for the same event with format #{format}" do
      single_event = FactoryGirl.create(:single_event)
      user = FactoryGirl.create(:bodo)
      sign_in user

      post :update, single_event_id: single_event.id, event_id: single_event.event.id, format: format, state: :push
      post :update, single_event_id: single_event.id, event_id: single_event.event.id, format: format, state: :push

      single_event.users.length.should == 1
      assert_response_for single_event, format
    end

    it "should not delete participate if not participant of event with format #{format}" do
      single_event = FactoryGirl.create(:single_event)
      FactoryGirl.create(:bodo)

      post :update, single_event_id: single_event.id, event_id: single_event.event.id, format: format, state: :delete

      single_event.reload

      single_event.users.length.should == 0
      flash[:error].should_not be_nil
      assert_response_for single_event, format
    end
  end
end
