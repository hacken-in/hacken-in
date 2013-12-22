require 'forwardable'
require 'day'

# Filter, sort and group a list of single events
# (It is not aware that something like a database or Rails exists)
class Calendar
  extend Forwardable

  # Does the calendar contain no entries?
  def_delegator :days, :empty?

  # Create a new instance given an event list and a user
  # The third argument is the class for creating the days
  def initialize(events, user, day_class = Day)
    @user = user
    @events = events
    @day_class = day_class
  end

  # Yield the days in the right order
  def each
    days.sort.each do |date, events|
      yield @day_class.new(date, events)
    end
  end

  private

  def days
    @days ||= @events.select { |event| event.is_for_user? @user }.group_by { |event| event.date }
  end
end
