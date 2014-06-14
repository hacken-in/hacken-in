class SearchResult
  attr_reader :entries

  class << self
    attr_accessor :per_page
  end

  self.per_page = 10

  def initialize(single_events, page, entry_class = CalendarEntry)
    first_page = self.class.per_page * (page - 1)
    last_page = first_page + self.class.per_page
    single_events = single_events[first_page...last_page]
    @entries = single_events.map { |event| entry_class.new(event) }
  end
end
