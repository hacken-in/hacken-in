require 'forwardable'
require 'active_support/core_ext/integer/time'

# Filter, sort and group a list of single events
# (It is not aware that something like a database or Rails exists)
class Calendar
  extend Forwardable

  # Create a new instance given a start date, region and user
  def initialize(start_date, region, user)
    @user = user
    @events = SingleEvent.list_all(from: start_date, in_next: 4.weeks, for_region: region)
  end

  # Yield the days in the right order
  def each
    days.sort.each do |date, events|
      yield Day.new(date, events)
    end
  end

  private

  def days
    @days ||= @events.select { |event| event.is_for_user? @user }.group_by { |event| event.date }
  end
end
