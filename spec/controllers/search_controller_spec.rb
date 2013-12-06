require 'spec_helper'

describe SearchController do
  include Devise::TestHelpers
  render_views

  it "should find single event with string 'Simple'" do
    pending "Search is not working right now"

    single_event = FactoryGirl.create(:single_event)
    single_event.occurrence = 1.week.from_now
    single_event.save
    get :index, search: "Simple", region: single_event.event.region.slug
    assert_select('div.calendar-line-title', "SimpleEvent (SimpleSingleEventName)")
  end

end
