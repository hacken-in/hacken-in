class Day
  attr_reader :date

  def initialize(date, events)
    @date = date
    @events = events
  end

  def each(&b)
    @events.sort.each(&b)
  end
end
