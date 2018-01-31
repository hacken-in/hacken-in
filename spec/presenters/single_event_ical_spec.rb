require 'spec_helper'

describe SingleEventIcal do
  it "should generate ical_event" do
    single_event = FactoryBot.create(:single_event)
    stamp = DateTime.now
    ical = <<~ical
      BEGIN:VEVENT
      DESCRIPTION:
      DTEND:#{(single_event.occurrence + single_event.duration * 60).strftime("%Y%m%dT%H%M%S")}
      DTSTAMP:#{stamp.strftime("%Y%m%dT%H%M%S")}
      DTSTART:#{single_event.occurrence.strftime("%Y%m%dT%H%M%S")}
      LOCATION:Deutz-Mülheimerstraße 129\\, 51063 Köln
      SEQUENCE:0
      SUMMARY:SimpleEvent (SimpleSingleEventName)
      UID:uid
      URL:http://hacken.dev/events/#{single_event.event.id}/dates/#{single_event.id}
      END:VEVENT
    ical
    event = SingleEventIcal.new(single_event).to_ical_event
    event.uid = "uid"
    event.dtstamp = stamp
    expect(event.to_ical.strip.gsub("\r\n", "\n")).to eq ical.strip
  end
end
