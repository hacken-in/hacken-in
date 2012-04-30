require 'test_helper'

class IcalControllerTest < ActionController::TestCase
  include Devise::TestHelpers

  def generate_event_entry(single_event, description = "")
    duration = !single_event.duration.nil? ? single_event.duration * 60 : single_event.event.schedule.duration || 3600
    event  = "BEGIN:VEVENT\n"
    if single_event.full_day
      event += "DTEND;VALUE=DATE:#{single_event.occurrence.strftime("%Y%m%d")}\n"
      event += "DTSTART;VALUE=DATE:#{single_event.occurrence.strftime("%Y%m%d")}\n"
    else
      event += "DTEND;VALUE=DATE-TIME:#{(single_event.occurrence + duration).utc.strftime("%Y%m%dT%H%M%SZ")}\n"
      event += "DTSTART;VALUE=DATE-TIME:#{single_event.occurrence.utc.strftime("%Y%m%dT%H%M%SZ")}\n"
    end
    event += "DESCRIPTION:#{description}\n"
    event += "URL:http://hcking.dev/events/#{single_event.event.id}/single_events/#{single_event.id}\n"
    event += "SUMMARY:#{single_event.title}\n"

    loc = [single_event.location, single_event.address].delete_if{|d|d.blank?}.join(", ").strip
    event += "LOCATION:#{loc.gsub(",", "\\,")}\n" unless loc.blank?
    event += "END:VEVENT\n"
  end

  def setup
    @user = FactoryGirl.create(:user)
    @user.hate_list << "php"
    @user.save

    @vcal_start =<<DESC
BEGIN:VCALENDAR
PRODID;X-RICAL-TZSOURCE=TZINFO:-//com.denhaven2/NONSGML ri_cal gem//EN
CALSCALE:GREGORIAN
VERSION:2.0
DESC

    @vcal_end =<<DESC
END:VCALENDAR
DESC

    event = FactoryGirl.create(:simple)
    time = Time.now + 12.hours
    event.schedule.add_recurrence_time(time)
    event.url = "url"
    event.description = "description"
    event.tag_list << "php"
    event.save
    event.single_events.first.users << @user
    @vcal_event = generate_event_entry(event.single_events.first, "description")

    event2 = FactoryGirl.create(:simple)
    time2 = (Date.today + 3.days).to_time
    event2.schedule.add_recurrence_time(time2)
    event2.tag_list << "php"
    event2.full_day = true
    event2.location = "home"
    event2.street = "street"
    event2.zipcode = "zipcode"
    event2.city = "cologne"
    event2.save
    @vcal_event2 = generate_event_entry(event2.single_events.first)

    event3 = FactoryGirl.create(:simple)
    time3 = (Time.now + 24.hours).beginning_of_day
    event3.schedule.add_recurrence_time(time3)
    event3.full_day = true
    event3.street = "street"
    event3.zipcode = "zipcode"
    event3.city = "cologne"
    event3.save
    @vcal_event3 = generate_event_entry(event3.single_events.first)

    event4 = FactoryGirl.create(:simple)
    time4 = (Time.now + 48.hours).beginning_of_day
    event4.schedule.add_recurrence_time(time4)
    event4.full_day = true
    event4.location = "home"
    event4.city = "cologne"
    event4.save
    se = event4.single_events.first
    se.topic = "First Event"
    se.description = "First Event Description"
    se.save
    @vcal_event4 = generate_event_entry(event4.single_events.first, "First Event Description")

    event5 = FactoryGirl.create(:simple)
    time5 = (Time.now + 48.hours).beginning_of_day
    event5.schedule.add_recurrence_time(time5)
    event5.full_day = false
    event5.location = "home"
    event5.city = "cologne"
    event5.save
    se = event5.single_events.first
    se.topic = "First Event"
    se.description = "First Event Description"
    se.full_day = true
    se.save
    @vcal_event5 = generate_event_entry(event5.single_events.first, "First Event Description")

    event6 = FactoryGirl.create(:simple)
    time6 = (Time.now + 48.hours).beginning_of_day
    event6.schedule.add_recurrence_time(time6)
    event6.full_day = false
    event6.location = "home"
    event6.city = "cologne"
    event6.description = "event text"
    event6.save
    se = event6.single_events.first
    se.topic = "First Event"
    se.description = "First Event Description"
    se.duration = 5
    se.save
    @vcal_event6 = generate_event_entry(event6.single_events.first, "First Event Description\\n\\nevent text")
  end

  test "should get general ical calendar" do
    get :general
    assert_response :success
    assert_equal "text/calendar; charset=UTF-8", @response.headers["Content-Type"]

    assert @response.body.start_with? @vcal_start
    assert @response.body.end_with? @vcal_end
    assert @response.body.include? @vcal_event
    assert @response.body.include? @vcal_event2
    assert @response.body.include? @vcal_event3
    assert @response.body.include? @vcal_event4
    assert @response.body.include? @vcal_event5
    assert @response.body.include? @vcal_event6
  end

  test "should get empty personalized ical calendar if no or wrong guid given" do
    get :personalized
    assert_response :success
    assert_equal "text/calendar; charset=UTF-8", @response.headers["Content-Type"]
    assert_equal "#{@vcal_start}#{@vcal_end}",@response.body

    get :personalized, {guid: "wrongguid"}
    assert_response :success
    assert_equal "text/calendar; charset=UTF-8", @response.headers["Content-Type"]
    assert_equal "#{@vcal_start}#{@vcal_end}",@response.body
  end

  test "should get personalized ical calendar" do
    get :personalized, {guid: "userguid"}
    assert_response :success
    assert_equal "text/calendar; charset=UTF-8", @response.headers["Content-Type"]

    assert @response.body.start_with? @vcal_start
    assert @response.body.end_with? @vcal_end
    assert @response.body.include? @vcal_event
    assert !@response.body.include?(@vcal_event2)
    assert !@response.body.include?(@vcal_event3)
    assert !@response.body.include?(@vcal_event4)
    assert !@response.body.include?(@vcal_event5)
    assert !@response.body.include?(@vcal_event6)
  end

  test "should get empty like welcome page ical calendar if no or wrong guid given" do
    get :like_welcome_page
    assert_response :success
    assert_equal "text/calendar; charset=UTF-8", @response.headers["Content-Type"]
    assert_equal "#{@vcal_start}#{@vcal_end}",@response.body

    get :like_welcome_page, {guid: "wrongguid"}
    assert_response :success
    assert_equal "text/calendar; charset=UTF-8", @response.headers["Content-Type"]
    assert_equal "#{@vcal_start}#{@vcal_end}",@response.body
  end

  test "should get like welcome page ical calendar" do
    get :like_welcome_page, {guid: "userguid"}
    assert_response :success
    assert_equal "text/calendar; charset=UTF-8", @response.headers["Content-Type"]

    assert @response.body.start_with? @vcal_start
    assert @response.body.end_with? @vcal_end
    assert @response.body.include? @vcal_event
    assert !@response.body.include?(@vcal_event2)
    assert @response.body.include?(@vcal_event3)
    assert @response.body.include?(@vcal_event4)
    assert @response.body.include?(@vcal_event5)
    assert @response.body.include?(@vcal_event6)
  end
end
