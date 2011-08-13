require 'test_helper'

class IcalControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  test "should get ical" do
    event = FactoryGirl.create(:simple)
    time = Time.now + 12.hours
    event.schedule.add_recurrence_date(time)
    event.description="description"
    event.url = "url"
    event.save

    event2 = FactoryGirl.create(:simple)
    time2 = (Date.today + 3.days).to_time
    event2.schedule.add_recurrence_date(time2)
    event2.full_day = true
    event2.save

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
DESCRIPTION:description
URL:url
SUMMARY:SimpleEvent
LOCATION:\\, \\, 
END:VEVENT
BEGIN:VEVENT
DTEND;VALUE=DATE:#{time2.strftime("%Y%m%d")}
DTSTART;VALUE=DATE:#{time2.strftime("%Y%m%d")}
DESCRIPTION:
SUMMARY:SimpleEvent
LOCATION:\\, \\, 
END:VEVENT
END:VCALENDAR
DESC

    assert_equal expected,  @response.body
  end

end
