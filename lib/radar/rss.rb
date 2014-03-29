require 'ruby_meetup'
require 'open-uri'

module Radar
  class Rss < Base

    def next_events
      feed = Feedjira::Feed.parse open(@radar_setting.url, &:read)
      entries = feed.entries.sort_by(&:published)
      if @radar_setting.last_processed.nil?
        entries = entries[1..4]
      else
        entries.delete_if do |entry|
          entry.published < @radar_setting.last_processed
        end
      end
      entries.reverse.map do |entry|
        parse_event(entry)
      end
    end

    def parse_event(event)
      {
        id: event.id,
        url: event.url,
        title: event.title,
        description: event.summary,
      }
    end

  end
end
