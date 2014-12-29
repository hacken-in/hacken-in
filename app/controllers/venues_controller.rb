class VenuesController < ApplicationController
  def show
    @venue = Venue.find(params[:id])
    @next_events = SingleEventsByDay.new(@venue.single_events.today_or_in_future.limit(6)).days
  end
end
