require 'spec_helper'

def assert_response_for single_event, format, query_params={}
  assert_template(/single_events\/_participants|participates\/update/) if format == :js
  assert_redirected_to event_single_event_path(single_event.event, single_event, query_params) if format == :html
end

describe ParticipatesController, type: :controller do
  [:html, :js].each do |format|
    it "should create participate with format #{format}" do
      single_event = FactoryGirl.create(:single_event)
      user = FactoryGirl.create(:bodo)
      sign_in user

      post :update, single_event_id: single_event.id, event_id: single_event.event.id, format: format, state: :push

      expect(single_event.users.first).to eq(user)
      assert_response_for single_event, format
    end

    it "should delete participate with format #{format}" do
      single_event = FactoryGirl.create(:single_event)
      user = FactoryGirl.create(:bodo)
      single_event.users << user
      sign_in user

      post :update, single_event_id: single_event.id, event_id: single_event.event.id, format: format, state: :delete

      single_event.reload

      expect(single_event.users.length).to eq(0)
      assert_response_for single_event, format
    end

    it "should not generate a new uuid if one is already set with format #{format}" do
      single_event = FactoryGirl.create(:single_event)
      old_cookie_value = cookies[:hacken_uuid] = "ich_habe_schon_eine_id"

      post :update, single_event_id: single_event.id, event_id: single_event.event.id, format: format, state: :push, name: "Hans Wurst", email: "hans@wurst.de"

      expect(cookies[:hacken_uuid]).to eq(old_cookie_value)
    end

    it "should not create participate two times for the same event with format #{format}" do
      single_event = FactoryGirl.create(:single_event)
      user = FactoryGirl.create(:bodo)
      sign_in user

      post :update, single_event_id: single_event.id, event_id: single_event.event.id, format: format, state: :push
      post :update, single_event_id: single_event.id, event_id: single_event.event.id, format: format, state: :push

      expect(single_event.users.length).to eq(1)
      assert_response_for single_event, format
    end
  end
end
