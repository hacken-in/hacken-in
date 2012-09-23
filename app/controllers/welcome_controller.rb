
class WelcomeController < ApplicationController
  def index
    single_events = SingleEvent.recent_to_soon(4.weeks)

    @single_events_by_day = SingleEvent.catalog_by_day(single_events, Date.today - 4.weeks, Date.today + 4.weeks)
  end

end

