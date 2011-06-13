class EventsController < ApplicationController

  def show
    @event = Event.find_by_id(params[:id])
  end

end
