class SearchResult
  attr_reader :entries
  PER_PAGE = 10

  def initialize(single_events, page, entry_class = CalendarEntry)
    single_events = Kaminari.paginate_array(single_events).page(page).per(PER_PAGE)
    @entries = single_events.map { |event| entry_class.new(event) }
  end
end
