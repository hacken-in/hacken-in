require 'active_support/core_ext/integer/time'

# Filter, sort and group a list of single events
# (It is not aware that something like a database or Rails exists)
class Calendar
  # Create a new instance given a start date, region and user
  def initialize(start_date, region, user)
    @user = user
    @events = SingleEvent.list_all(from: start_date, in_next: 4.weeks, for_region: region)
  end

  # The days in the calendar in the right order
  def days
    @days ||= sorted_grouped_events_for_user.map do |date, events|
      Day.new(date, events)
    end
  end

  private

  def sorted_grouped_events_for_user
    grouped_events_for_user.sort
  end

  def grouped_events_for_user
    events_for_user.group_by { |event| event.date }
  end

  def events_for_user
    @events.select { |event| event.is_for_user? @user }
  end
end
