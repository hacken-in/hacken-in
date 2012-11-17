class EventsController < ApplicationController
  respond_to :html, :xml

  def index
    redirect_to :calendar
  end

  def show
    event = Event.find params[:id]
    latest_event = event.single_events.last

    if latest_event
      redirect_to event_single_event_path(event, latest_event)
    else
      redirect_to :calendar
    end
  end

end
