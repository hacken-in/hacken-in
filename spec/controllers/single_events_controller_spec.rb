# encoding: utf-8
require 'spec_helper'

describe SingleEventsController, type: :controller do
  include Devise::TestHelpers

  it "should be successful" do
    single_event = FactoryGirl.create(:single_event)
    get :show, id: single_event.id, event_id: single_event.event.id
    expect(response).to be_success
  end

  it "should be successful as user" do
    single_event = FactoryGirl.create(:single_event)
    user = FactoryGirl.create(:bodo)
    sign_in user

    get :show, id: single_event.id, event_id: single_event.event.id
    expect(response).to be_success
  end

  it "should be successful as participated user" do
    single_event = FactoryGirl.create(:single_event)
    user = FactoryGirl.create(:bodo)
    single_event.users << user
    sign_in user

    get :show, id: single_event.id, event_id: single_event.event.id
    expect(response).to be_success
  end
end
