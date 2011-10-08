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

    vcal_start =<<DESC
BEGIN:VCALENDAR
PRODID;X-RICAL-TZSOURCE=TZINFO:-//com.denhaven2/NONSGML ri_cal gem//EN
CALSCALE:GREGORIAN
VERSION:2.0
DESC

    vcal_end =<<DESC
END:VCALENDAR
DESC
    
  vcal_event =<<DESC
BEGIN:VEVENT
DTEND;VALUE=DATE-TIME:#{(time + 1.hour).utc.strftime("%Y%m%dT%H%M%SZ")}
DTSTART;VALUE=DATE-TIME:#{time.utc.strftime("%Y%m%dT%H%M%SZ")}
DESCRIPTION:description
URL:url
SUMMARY:SimpleEvent
END:VEVENT
DESC

  vcal_event2 =<<DESC
BEGIN:VEVENT
DTEND;VALUE=DATE:#{time2.strftime("%Y%m%d")}
DTSTART;VALUE=DATE:#{time2.strftime("%Y%m%d")}
DESCRIPTION:
SUMMARY:SimpleEvent
LOCATION:home\\, street\\, zipcode cologne
END:VEVENT
DESC

  vcal_event3 =<<DESC
BEGIN:VEVENT
DTEND;VALUE=DATE:#{time3.strftime("%Y%m%d")}
DTSTART;VALUE=DATE:#{time3.strftime("%Y%m%d")}
DESCRIPTION:
SUMMARY:SimpleEvent
LOCATION:street\\, zipcode cologne
END:VEVENT
DESC

  vcal_event4 =<<DESC
BEGIN:VEVENT
DTEND;VALUE=DATE:#{time4.strftime("%Y%m%d")}
DTSTART;VALUE=DATE:#{time4.strftime("%Y%m%d")}
DESCRIPTION:
SUMMARY:SimpleEvent
LOCATION:home\\, cologne
END:VEVENT
DESC

    assert @response.body.start_with? vcal_start
    assert @response.body.end_with? vcal_end
    assert @response.body.include? vcal_event
    assert @response.body.include? vcal_event2
    assert @response.body.include? vcal_event3
    assert @response.body.include? vcal_event4
  end

end
