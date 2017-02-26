class EventsController < ApplicationController
  respond_to :html, :xml

  def show
    event = Event.find params[:id]
    closest_single_event = event.closest_single_event

    if closest_single_event
      redirect_to event_single_event_path(event, closest_single_event)
    else
      redirect_to :calendar
    end
  end
end
