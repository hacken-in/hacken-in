require 'ruby_meetup'

module Radar
  class Meetup

    def initialize(radar_setting)
      @radar_setting = radar_setting
    end

    def fetch
      p "fetchin meetup"
    end

    def group_urlname
      @radar_setting.url.match(/http(?:s?):\/\/www.meetup.com\/([^\/]*)/)[1]
    end

    def next_events
      json = JSON.parse(RubyMeetup::ApiKeyClient.new.get_path("/2/events", {group_urlname: group_urlname}))
      json["results"].map do |event|
        cleanup_event(event)
      end
    end

    def cleanup_event(event)
      result = {
        id: event["id"],
        url: event["event_url"],
        title: event["name"],
        description: event["description"],
        venue: get_venue(event),
        updated: Time.at(event["updated"] / 1000),
        duration: (event["duration"] || 0) / 1000
      }
      result[:time] = get_time(event)
      result
    end

    def get_venue(event)
      if venue = event["venue"]
        [venue["name"],
         venue["address_1"],
         venue["address_2"],
         venue["address_3"],
         venue["city"],
         venue["country"]
        ].compact.join(", ")
      end
    end

    def get_time(event)
      date = Time.at(event["time"] / 1000)
      Time.new(date.year,
               date.month,
               date.day,
               date.hour,
               date.min,
               date.sec,
               get_offset(event["utc_offset"]))
    end

    def get_offset(offset)
      return nil if offset.nil?
      millis  = (offset / 1000).abs
      hour    = millis / 60 / 60
      minutes = (millis / 60) % 60

      result = "+"
      result = "-" if offset < 0
      result += "%02d:%02d" % [hour, minutes]
      result
    end

  end
end
