require 'active_support/core_ext/integer/time'

# Filter, sort and group a list of single events
class Calendar
  # Create a new instance given a start date, region and user
  def initialize(start_date, region, user)
    @user = user
    @events = SingleEvent.list_all(from: start_date, in_next: 4.weeks, for_region: region)
  end

  # The days in the calendar in the right order
  def days
    SingleEventsByDay.new(events_for_user).days
  end

  private

  def events_for_user
    @events.select { |event| event.is_for_user? @user }
  end
end
