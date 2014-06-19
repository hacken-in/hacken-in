class SearchResult
  def initialize(single_events)
    @entries = single_events
  end

  def days(entry_class = Day)
    @entries.group_by { |event| event.date }.sort.map do |date, events|
      entry_class.new(date, events)
    end
  end
end
