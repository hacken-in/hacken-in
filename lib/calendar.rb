
class Calendar

  def self.events_by_day(events)
    events_by_day = Hash.new { |hash, key| hash[key] = [] }

    events.each do |event|
      events_by_day[event.occurrence.to_date] << event
    end

    events_by_day
  end

  def self.fill_gaps(days, first_day, last_day, min_entries=8)

    (first_day..last_day).each do |day|
      days[day] = [] unless days.key? day
      events_for_day = days[day]

      if events_for_day.size < min_entries
        (min_entries - events_for_day.size).times do
          days[day] << nil
        end
      end
    end

    days.sort
  end

end

