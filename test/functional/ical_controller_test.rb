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
    event2.location = "home"
    event2.street = "street"
    event2.zipcode = "zipcode"
    event2.city = "cologne"
    event2.save

    event3 = FactoryGirl.create(:simple)
    time3 = Time.now + 24.hours
    event3.schedule.add_recurrence_date(time3)
    event3.full_day = true
    event3.street = "street"
    event3.zipcode = "zipcode"
    event3.city = "cologne"
    event3.save

    event4 = FactoryGirl.create(:simple)
    time4 = Time.now + 48.hours
    event4.schedule.add_recurrence_date(time4)
    event4.full_day = true
    event4.location = "home"
    event4.city = "cologne"
    event4.save

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
END:VEVENT
BEGIN:VEVENT
DTEND;VALUE=DATE:#{time3.strftime("%Y%m%d")}
DTSTART;VALUE=DATE:#{time3.strftime("%Y%m%d")}
DESCRIPTION:
SUMMARY:SimpleEvent
LOCATION:street\\, zipcode cologne
END:VEVENT
BEGIN:VEVENT
DTEND;VALUE=DATE:#{time4.strftime("%Y%m%d")}
DTSTART;VALUE=DATE:#{time4.strftime("%Y%m%d")}
DESCRIPTION:
SUMMARY:SimpleEvent
LOCATION:home\\, cologne
END:VEVENT
BEGIN:VEVENT
DTEND;VALUE=DATE:#{time2.strftime("%Y%m%d")}
DTSTART;VALUE=DATE:#{time2.strftime("%Y%m%d")}
DESCRIPTION:
SUMMARY:SimpleEvent
LOCATION:home\\, street\\, zipcode cologne
END:VEVENT
END:VCALENDAR
DESC

    assert_equal expected,  @response.body
  end

end
