
class Calendar

  def self.events_by_day(events)
    events.group_by { |event| event.occurrence.to_date }
  end

  def self.fill_gaps(days, first_day, last_day, min_entries=8)

    (first_day..last_day).each do |day|
      days[day] = Array.new(min_entries) unless days.key?(day)

      if days[day].size < min_entries
        gaps_filled = days[day].in_groups_of(min_entries).first
        days[day] = gaps_filled
      end
    end

    days.sort
  end

end

