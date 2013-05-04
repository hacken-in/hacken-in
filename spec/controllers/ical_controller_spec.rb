require 'spec_helper'

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
  event += "URL:http://hcking.dev/koeln/events/#{single_event.event.id}/dates/#{single_event.id}\n"
  event += "SUMMARY:#{single_event.full_name}\n"

  loc = [single_event.venue_info, single_event.venue.address].delete_if{|d|d.blank?}.join(", ").strip
  event += "LOCATION:#{loc.gsub(",", "\\,")}\n" unless loc.blank?
  event += "END:VEVENT\n"
end

describe IcalController do
  include Devise::TestHelpers

  before do
    @user = FactoryGirl.create(:user)
    @user.hate_list << "php"
    @user.like_list << "ruby"
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
    event2.save
    @vcal_event2 = generate_event_entry(event2.single_events.first)

    event3 = FactoryGirl.create(:simple)
    time3 = (Time.now + 24.hours).beginning_of_day
    event3.schedule.add_recurrence_time(time3)
    event3.full_day = true
    event3.save
    @vcal_event3 = generate_event_entry(event3.single_events.first)

    event4 = FactoryGirl.create(:simple)
    time4 = (Time.now + 48.hours).beginning_of_day
    event4.schedule.add_recurrence_time(time4)
    event4.full_day = true
    event4.save
    se = event4.single_events.first
    se.name = "First Event"
    se.description = "First Event Description"
    se.save
    @vcal_event4 = generate_event_entry(event4.single_events.first, "First Event Description")

    event5 = FactoryGirl.create(:simple)
    time5 = (Time.now + 48.hours).beginning_of_day
    event5.schedule.add_recurrence_time(time5)
    event5.full_day = false
    event5.save
    se = event5.single_events.first
    se.name = "First Event"
    se.description = "First Event Description"
    se.full_day = true
    se.save
    @vcal_event5 = generate_event_entry(event5.single_events.first, "First Event Description")

    event6 = FactoryGirl.create(:simple)
    time6 = (Time.now + 48.hours).beginning_of_day
    event6.schedule.add_recurrence_time(time6)
    event6.full_day = false
    event6.description = "event text"
    event6.save
    se = event6.single_events.first
    se.name = "First Event"
    se.description = "First Event Description"
    se.duration = 5
    se.save
    @vcal_event6 = generate_event_entry(event6.single_events.first, "First Event Description\\n\\nevent text")

    event7 = FactoryGirl.create(:simple)
    time7 = (Date.today + 3.days).to_time
    event7.schedule.add_recurrence_time(time7)
    event7.tag_list << "php"
    event7.tag_list << "ruby"
    event7.full_day = true
    event7.save
    @vcal_event7 = generate_event_entry(event7.single_events.first)
  end

  it "should get general ical calendar" do
    get :general
    expect(response.code).to eq("200")
    @response.headers["Content-Type"].should == "text/calendar; charset=UTF-8"

    @response.body.should start_with @vcal_start
    @response.body.should end_with @vcal_end
    @response.body.should include @vcal_event
    @response.body.should include @vcal_event2
    @response.body.should include @vcal_event3
    @response.body.should include @vcal_event4
    @response.body.should include @vcal_event5
    @response.body.should include @vcal_event6
    @response.body.should include @vcal_event7
  end

  it "should get empty personalized ical calendar if no guid given" do
    get :personalized, guid: ""
    expect(response.code).to eq("200")
    @response.headers["Content-Type"].should == "text/calendar; charset=UTF-8"
    @response.body.should == "#{@vcal_start}#{@vcal_end}"
  end

  it "should get empty personalized ical calendar if wrong guid given" do
    get :personalized, guid: "wrongguid"
    expect(response.code).to eq("200")
    @response.headers["Content-Type"].should == "text/calendar; charset=UTF-8"
    @response.body.should == "#{@vcal_start}#{@vcal_end}"
  end

  it "should get personalized ical calendar" do
    get :personalized, guid: "userguid"
    expect(response.code).to eq("200")
    @response.headers["Content-Type"].should == "text/calendar; charset=UTF-8"

    @response.body.should start_with @vcal_start
    @response.body.should end_with @vcal_end
    @response.body.should include @vcal_event
    @response.body.should_not include @vcal_event2
    @response.body.should_not include @vcal_event3
    @response.body.should_not include @vcal_event4
    @response.body.should_not include @vcal_event5
    @response.body.should_not include @vcal_event6
    @response.body.should_not include @vcal_event7
  end

  it "should get empty like welcome page ical calendar if no guid given" do
    get :like_welcome_page, guid: ""
    expect(response.code).to eq("200")
    @response.headers["Content-Type"].should == "text/calendar; charset=UTF-8"
    @response.body.should == "#{@vcal_start}#{@vcal_end}"
  end

  it "should get empty like welcome page ical calendar if wrong guid given" do
    get :like_welcome_page, guid: "wrongguid"
    expect(response.code).to eq("200")
    @response.headers["Content-Type"].should == "text/calendar; charset=UTF-8"
    @response.body.should == "#{@vcal_start}#{@vcal_end}"
  end

  it "should get like welcome page ical calendar" do
    get :like_welcome_page, {guid: "userguid"}
    expect(response.code).to eq("200")
    @response.headers["Content-Type"].should == "text/calendar; charset=UTF-8"

    @response.body.should start_with @vcal_start
    @response.body.should end_with @vcal_end
    @response.body.should include @vcal_event
    @response.body.should_not include @vcal_event2
    @response.body.should include @vcal_event3
    @response.body.should include @vcal_event4
    @response.body.should include @vcal_event5
    @response.body.should include @vcal_event6
    @response.body.should include @vcal_event7
  end
end
