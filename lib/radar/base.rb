require 'ruby_meetup'

module Radar
  class Base

    def initialize(radar_setting)
      @radar_setting = radar_setting
    end

    def fetch(start_time = Time.now)
      event_ids = []
      begin
        next_events.each do |event|
          next if event[:time] && event[:time] < start_time
          event_ids << event[:id]
          update_event(event)
        end
        mark_missing(start_time, event_ids)
        @radar_setting.last_result = "OK"
      rescue => e
        @radar_setting.last_result = e.message[0..254]
        Bugsnag.notify e
      end
      @radar_setting.last_processed = start_time
      @radar_setting.save
    end

    def update_event(event)
      entry = @radar_setting.entries.find_or_create_by(entry_id: event[:id].to_s)
      if (entry.entry_date != event[:time] ||
          entry.previous_confirmed_content != event.except(:id, :time))

        entry.entry_date = event[:time]
        entry.content    = event.except(:id, :time)
        entry.entry_type = entry.entry_type.nil? ? "NEW" : "UPDATE"
        entry.state      = "UNCONFIRMED"
        entry.save
      end
    end

    def mark_missing(start_time, event_ids)
      # Cast event_ids to string because they are stored as type varchar
      # PostgreSQL will refuse to compare character varying <> integer
      @radar_setting.entries.where("entry_date > ? and entry_id not in (?)", start_time, event_ids.map(&:to_s)).each do |entry|
        if entry.entry_type != "MISSING"
          entry.entry_type = "MISSING"
          entry.content = {}
          entry.state = "UNCONFIRMED"
          entry.save
        end
      end
    end

  end
end
