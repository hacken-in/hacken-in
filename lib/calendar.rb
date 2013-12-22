require 'day'

# Filter, sort and group a list of single events
# (It is not aware that something like a database or Rails exists)
class Calendar
  # Create a new instance given an event list and a user
  # The third argument is the class for creating the days
  def initialize(event_list, user, day_class = Day)
    @event_list = event_list
    @day_class = day_class
  end

  # Yield the days in the right order
  def each
    @event_list.select(&:is_for_user?).group_by { |event| event.date }.sort.each do |date, events|
      yield @day_class.new(date, events)
    end
  end
end
