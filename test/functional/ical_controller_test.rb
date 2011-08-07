require 'test_helper'

class IcalControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should get ical" do
    event = FactoryGirl.create(:simple)
    time = Time.now + 12.hours
    event.schedule.add_recurrence_date(time)
    event.save
    get :index
    assert_response :success
    assert_equal "text/calendar", @response.headers["Content-Type"]

    expected = <<DESC
BEGIN:VCALENDAR
PRODID;X-RICAL-TZSOURCE=TZINFO:-//com.denhaven2/NONSGML ri_cal gem//EN
CALSCALE:GREGORIAN
VERSION:2.0
BEGIN:VEVENT
DTEND;VALUE=DATE-TIME:#{(time + 1.hour).utc.strftime("%Y%m%dT%H%M%SZ")}
DTSTART;VALUE=DATE-TIME:#{time.utc.strftime("%Y%m%dT%H%M%SZ")}
DESCRIPTION:
SUMMARY:SimpleEvent
LOCATION:\\, \\, 
END:VEVENT
END:VCALENDAR
DESC

    assert_equal expected,  @response.body
  end

# ToDo: Sanatize + URL handling

end
