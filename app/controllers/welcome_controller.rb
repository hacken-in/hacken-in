class WelcomeController < ApplicationController
  def index
    single_events = SingleEvent.recent_to_soon(4.weeks)
    events_by_day = Calendar.events_by_day(single_events)
    @mini_calendar_events = Calendar.fill_gaps(events_by_day, Date.today - 4.weeks, Date.today + 4.weeks)
    @first_row = Box.active.where("position <= 3")
    @second_row = Box.active.where("position > 3")
  end
end
