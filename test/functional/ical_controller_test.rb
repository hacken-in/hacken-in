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
    time3 = (Time.now + 24.hours).beginning_of_day
    event3.schedule.add_recurrence_date(time3)
    event3.full_day = true
    event3.street = "street"
    event3.zipcode = "zipcode"
    event3.city = "cologne"
    event3.save

    event4 = FactoryGirl.create(:simple)
    time4 = (Time.now + 48.hours).beginning_of_day
    event4.schedule.add_recurrence_date(time4)
    event4.full_day = true
    event4.location = "home"
    event4.city = "cologne"
    event4.save
    se = event4.single_events.first
    se.topic = "First Event"
    se.description = "First Event Description"
    se.save

    event5 = FactoryGirl.create(:simple)
    time5 = (Time.now + 48.hours).beginning_of_day
    event5.schedule.add_recurrence_date(time5)
    event5.full_day = false
    event5.location = "home"
    event5.city = "cologne"
    event5.save
    se = event5.single_events.first
    se.topic = "First Event"
    se.description = "First Event Description"
    se.full_day = true
    se.save

    event6 = FactoryGirl.create(:simple)
    time6 = (Time.now + 48.hours).beginning_of_day
    event6.schedule.add_recurrence_date(time6)
    event6.full_day = false
    event6.location = "home"
    event6.city = "cologne"
    event6.save
    se = event6.single_events.first
    se.topic = "First Event"
    se.description = "First Event Description"
    se.duration = 5
    se.save


    get :general
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
URL:http://hcking.dev/events/#{event.id}/single_events/#{event.single_events.first.id}
SUMMARY:SimpleEvent
END:VEVENT
DESC

  vcal_event2 =<<DESC
BEGIN:VEVENT
DTEND;VALUE=DATE:#{time2.strftime("%Y%m%d")}
DTSTART;VALUE=DATE:#{time2.strftime("%Y%m%d")}
DESCRIPTION:
URL:http://hcking.dev/events/#{event2.id}/single_events/#{event2.single_events.first.id}
SUMMARY:SimpleEvent
LOCATION:home\\, street\\, zipcode cologne
END:VEVENT
DESC

  vcal_event3 =<<DESC
BEGIN:VEVENT
DTEND;VALUE=DATE:#{time3.strftime("%Y%m%d")}
DTSTART;VALUE=DATE:#{time3.strftime("%Y%m%d")}
DESCRIPTION:
URL:http://hcking.dev/events/#{event3.id}/single_events/#{event3.single_events.first.id}
SUMMARY:SimpleEvent
LOCATION:street\\, zipcode cologne
END:VEVENT
DESC

  vcal_event4 =<<DESC
BEGIN:VEVENT
DTEND;VALUE=DATE:#{time4.strftime("%Y%m%d")}
DTSTART;VALUE=DATE:#{time4.strftime("%Y%m%d")}
DESCRIPTION:First Event Description
URL:http://hcking.dev/events/#{event4.id}/single_events/#{event4.single_events.first.id}
SUMMARY:SimpleEvent (First Event)
LOCATION:home\\, cologne
END:VEVENT
DESC

  vcal_event5 =<<DESC
BEGIN:VEVENT
DTEND;VALUE=DATE:#{time5.strftime("%Y%m%d")}
DTSTART;VALUE=DATE:#{time5.strftime("%Y%m%d")}
DESCRIPTION:First Event Description
URL:http://hcking.dev/events/#{event5.id}/single_events/#{event5.single_events.first.id}
SUMMARY:SimpleEvent (First Event)
LOCATION:home\\, cologne
END:VEVENT
DESC

  vcal_event6 =<<DESC
BEGIN:VEVENT
DTEND;VALUE=DATE-TIME:#{(time6+5.minutes).strftime("%Y%m%dT%H%M%SZ")}
DTSTART;VALUE=DATE-TIME:#{time6.strftime("%Y%m%dT%H%M%SZ")}
DESCRIPTION:First Event Description
URL:http://hcking.dev/events/#{event6.id}/single_events/#{event6.single_events.first.id}
SUMMARY:SimpleEvent (First Event)
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
