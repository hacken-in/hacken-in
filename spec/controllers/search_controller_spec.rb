require 'spec_helper'

describe SearchController do
  include Devise::TestHelpers
  render_views

  it "should get index" do
    sign_in FactoryGirl.create(:user)
    get :index
    response.should be_success
  end

  it "should find single event with string 'Simple'" do
    single_event = FactoryGirl.create(:single_event)
    single_event.occurrence = 1.week.from_now
    single_event.save
    get :index, search: "Simple"
    assert_select('div.calendar-line-title', "SimpleEvent (SimpleSingleEventName)")
  end

end
