require 'spec_helper'

def generate_event_entry(single_event, description = "")
  duration = !single_event.duration.nil? ? single_event.duration * 60 : single_event.event.schedule.duration || 3600
  event = "(.*)"
  event += "BEGIN:VEVENT\r\n"
  event += "DESCRIPTION:#{description.gsub("\\n", "\\\\\\n")}\r\n"

  if single_event.full_day
    event += "DTEND:#{single_event.occurrence.strftime("%Y%m%d")}\r\n"
    event += "DTSTAMP:(.*)\r\n"
    event += "DTSTART:#{single_event.occurrence.strftime("%Y%m%d")}\r\n"
  else
    event += "DTEND:#{(single_event.occurrence + single_event.duration * 60).strftime("%Y%m%dT%H%M%S")}\r\n"
    event += "DTSTAMP:(.*)\r\n"
    event += "DTSTART:#{single_event.occurrence.strftime("%Y%m%dT%H%M%S")}\r\n"
  end
  loc = [single_event.venue_info, single_event.venue.address].delete_if{|d|d.blank?}.join(", ").strip
  event += "LOCATION:#{loc.gsub(",", "(.*)")}\r\n" unless loc.blank?
  event += "SEQUENCE:0\r\n"
  event += "SUMMARY:#{single_event.full_name.gsub("(", "\\\(").gsub(")", "\\\)")}\r\n"
  event += "UID:(.*)\r\n"
  event += "URL:http://hacken.dev/events/#{single_event.event.id}/dates/#{single_event.id}\r\n"
  event += "END:VEVENT\r\n"
  event += "(.*)"
  Regexp.new(event, Regexp::MULTILINE)
end

describe IcalController, type: :controller do
  before do
    @user = FactoryBot.create(:user)
    @user.hate_list << "php"
    @user.like_list << "ruby"
    @user.save

    @vcal_start =<<DESC
BEGIN:VCALENDAR\r
VERSION:2.0\r
CALSCALE:GREGORIAN\r
PRODID:iCalendar-Ruby\r
DESC

    @vcal_end =<<DESC
END:VCALENDAR\r
DESC

    event = FactoryBot.create(:simple)
    time = Time.now + 12.hours
    event.schedule.add_recurrence_time(time)
    event.url = "url"
    event.description = "description"
    event.tag_list << "php"
    event.save
    event.single_events.first.users << @user
    @vcal_event = generate_event_entry(event.single_events.first, "description")

    event2 = FactoryBot.create(:simple)
    time2 = (Date.today + 3.days).to_time
    event2.schedule.add_recurrence_time(time2)
    event2.tag_list << "php"
    event2.full_day = true
    event2.save
    @vcal_event2 = generate_event_entry(event2.single_events.first)

    event3 = FactoryBot.create(:simple)
    time3 = (Time.now + 24.hours).beginning_of_day
    event3.schedule.add_recurrence_time(time3)
    event3.full_day = true
    event3.save
    @vcal_event3 = generate_event_entry(event3.single_events.first)

    event4 = FactoryBot.create(:simple)
    time4 = (Time.now + 48.hours).beginning_of_day
    event4.schedule.add_recurrence_time(time4)
    event4.full_day = true
    event4.save
    se = event4.single_events.first
    se.name = "First Event"
    se.description = "First Event Description"
    se.save
    @vcal_event4 = generate_event_entry(event4.single_events.first, "First Event Description")

    event5 = FactoryBot.create(:simple)
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

    event6 = FactoryBot.create(:simple)
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

    event7 = FactoryBot.create(:simple)
    time7 = (Date.today + 3.days).to_time
    event7.schedule.add_recurrence_time(time7)
    event7.tag_list << "php"
    event7.tag_list << "ruby"
    event7.full_day = true
    event7.save
    @vcal_event7 = generate_event_entry(event7.single_events.first)

    event8 = FactoryBot.create(:berlin_event)
    time8 = (Date.today + 3.days).to_time
    event8.schedule.add_recurrence_time(time8)
    event8.tag_list << "php"
    event8.tag_list << "ruby"
    event8.full_day = true
    event8.save
    @vcal_event8 = generate_event_entry(event8.single_events.first)
  end

  it "should get general ical calendar for koeln" do
    get :general, region: "koeln"
    expect(response.code).to eq("200")
    expect(@response.headers["Content-Type"]).to eq "text/calendar; charset=UTF-8"

    expect(@response.body).to start_with @vcal_start
    expect(@response.body).to end_with @vcal_end
    expect(@response.body).to match @vcal_event
    expect(@response.body).to match @vcal_event2
    expect(@response.body).to match @vcal_event3
    expect(@response.body).to match @vcal_event4
    expect(@response.body).to match @vcal_event5
    expect(@response.body).to match @vcal_event6
    expect(@response.body).to match @vcal_event7
    expect(@response.body).not_to match @vcal_event8
  end

  it "should get general ical calendar for berlin" do
    get :general, region: "berlin"
    expect(response.code).to eq("200")
    expect(@response.headers["Content-Type"]).to eq "text/calendar; charset=UTF-8"

    expect(@response.body).to start_with @vcal_start
    expect(@response.body).to end_with @vcal_end
    expect(@response.body).not_to match @vcal_event
    expect(@response.body).not_to match @vcal_event2
    expect(@response.body).not_to match @vcal_event3
    expect(@response.body).not_to match @vcal_event4
    expect(@response.body).not_to match @vcal_event5
    expect(@response.body).not_to match @vcal_event6
    expect(@response.body).not_to match @vcal_event7
    expect(@response.body).to match @vcal_event8
  end

  it "should get empty personalized ical calendar if no guid given" do
    get :personalized, guid: "", region: "koeln"
    expect(response.code).to eq("200")
    expect(@response.headers["Content-Type"]).to eq "text/calendar; charset=UTF-8"
    expect(@response.body).to eq "#{@vcal_start}#{@vcal_end}"
  end

  it "should get empty personalized ical calendar if wrong guid given" do
    get :personalized, guid: "wrongguid", region: "koeln"
    expect(response.code).to eq("200")
    expect(@response.headers["Content-Type"]).to eq "text/calendar; charset=UTF-8"
    expect(@response.body).to eq "#{@vcal_start}#{@vcal_end}"
  end

  it "should get personalized ical calendar" do
    get :personalized, guid: "userguid", region: "koeln"
    expect(response.code).to eq("200")
    expect(@response.headers["Content-Type"]).to eq "text/calendar; charset=UTF-8"

    expect(@response.body).to start_with @vcal_start
    expect(@response.body).to end_with @vcal_end
    expect(@response.body).to match @vcal_event
    expect(@response.body).not_to match @vcal_event2
    expect(@response.body).not_to match @vcal_event3
    expect(@response.body).not_to match @vcal_event4
    expect(@response.body).not_to match @vcal_event5
    expect(@response.body).not_to match @vcal_event6
    expect(@response.body).not_to match @vcal_event7
    expect(@response.body).not_to match @vcal_event8
  end

  it "should get empty like welcome page ical calendar if no guid given" do
    get :like_welcome_page, guid: "", region: "koeln"
    expect(response.code).to eq("200")
    expect(@response.headers["Content-Type"]).to eq "text/calendar; charset=UTF-8"
    expect(@response.body).to eq "#{@vcal_start}#{@vcal_end}"
  end

  it "should get empty like welcome page ical calendar if wrong guid given" do
    get :like_welcome_page, guid: "wrongguid", region: "koeln"
    expect(response.code).to eq("200")
    expect(@response.headers["Content-Type"]).to eq "text/calendar; charset=UTF-8"
    expect(@response.body).to eq "#{@vcal_start}#{@vcal_end}"
  end

  it "should get like welcome page ical calendar for koeln" do
    get :like_welcome_page, guid: "userguid", region: "koeln"
    expect(response.code).to eq("200")
    expect(@response.headers["Content-Type"]).to eq "text/calendar; charset=UTF-8"

    expect(@response.body).to start_with @vcal_start
    expect(@response.body).to end_with @vcal_end
    expect(@response.body).to match @vcal_event
    expect(@response.body).not_to match @vcal_event2
    expect(@response.body).to match @vcal_event3
    expect(@response.body).to match @vcal_event4
    expect(@response.body).to match @vcal_event5
    expect(@response.body).to match @vcal_event6
    expect(@response.body).to match @vcal_event7
    expect(@response.body).not_to match @vcal_event8
  end

  it "should get like welcome page ical calendar for berlin" do
    get :like_welcome_page, guid: "userguid", region: "berlin"
    expect(response.code).to eq("200")
    expect(@response.headers["Content-Type"]).to eq "text/calendar; charset=UTF-8"

    expect(@response.body).to start_with @vcal_start
    expect(@response.body).to end_with @vcal_end
    expect(@response.body).not_to match @vcal_event
    expect(@response.body).not_to match @vcal_event2
    expect(@response.body).not_to match @vcal_event3
    expect(@response.body).not_to match @vcal_event4
    expect(@response.body).not_to match @vcal_event5
    expect(@response.body).not_to match @vcal_event6
    expect(@response.body).not_to match @vcal_event7
    expect(@response.body).to match @vcal_event8
  end

  it "should get ical calendar for everything" do
    get :everything
    expect(response.code).to eq("200")
    expect(@response.headers["Content-Type"]).to eq "text/calendar; charset=UTF-8"

    expect(@response.body).to start_with @vcal_start
    expect(@response.body).to end_with @vcal_end
    expect(@response.body).to match @vcal_event
    expect(@response.body).to match @vcal_event2
    expect(@response.body).to match @vcal_event3
    expect(@response.body).to match @vcal_event4
    expect(@response.body).to match @vcal_event5
    expect(@response.body).to match @vcal_event6
    expect(@response.body).to match @vcal_event7
    expect(@response.body).to match @vcal_event8
  end

  it "should render one single event" do
    get :for_single_event, id: Event.first.single_events.first.id
    expect(@response.body).to start_with @vcal_start
    expect(@response.body).to end_with @vcal_end
    expect(@response.body).to match @vcal_event
  end

end
