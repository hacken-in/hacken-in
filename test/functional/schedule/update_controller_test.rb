require 'test_helper'

class Schedule::UpdateControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should not update if user is not allowed to do this" do
    event = FactoryGirl.create(:simple)

    put :update, :event_id => event.id
    assert_redirected_to :controller => '/welcome', :action => 'index'
  end

  test "should update if user is allowed to do this" do
    event = FactoryGirl.create(:simple)
    event.schedule.start_date = Time.new(2011,1,1,12,00)
    event.schedule.duration = 60 * 60
    event.save

    sign_in FactoryGirl.create(:bodo)
    put :update, :event_id => event.id, :start_date => {
      "date(1i)" => "2012", "date(2i)" => "1", "date(3i)" => "1", 
      "date(4i)" => "12", "date(5i)" => "10"
    }, :duration => 60
    assert_redirected_to event_path(event)
    assert_nil flash[:alert]

    event = Event.find(event.id)
    assert_equal 60 * 60, event.schedule.duration
    assert_equal Time.new(2012, 1, 1, 12, 10), event.schedule.start_date
  end
end
