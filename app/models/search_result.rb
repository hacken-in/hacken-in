class SearchResult
  attr_reader :entries

  def initialize(single_events, entry_class = CalendarEntry)
    @entries = single_events.map { |event| entry_class.new(event) }
  end
end
