# encoding: utf-8
require 'ruby_meetup'
require 'open-uri'

module Radar
  class Ical < Base

    def next_events
      ical = open(@radar_setting.url, &:read)
      calendar = Icalendar.parse(ical, false)
      calendar.first.events.map do |event|
        parse_event(event)
      end
    end

    def parse_event(event)
      result = {
        id: event.start.to_s,
        url: event.url.to_s,
        title: (event.summary || "").force_encoding("utf-8"),
        description: (event.description || "").force_encoding("utf-8"),
        venue: event.location,
        time: event.start
      }
      if event.start && event.end &&
         !event.start.instance_of?(Date) && !event.end.instance_of?(Date)
        result[:duration] = (event.end.to_i - event.start.to_i) / 60
      end
      result
    end

  end
end
