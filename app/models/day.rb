class Day
  extend Forwardable

  attr_reader :date
  attr_reader :entries

  def initialize(date, events, entry_class = CalendarEntry)
    @date = date
    @entries = events.sort.map { |event| entry_class.new(event) }
  end

  def to_partial_path
    'modules/calendars/day'
  end
end
