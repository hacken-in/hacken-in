class EventsController < ApplicationController
  respond_to :html, :xml

  def index
    authorize! :index, Event
    @events = Event.order :name
    respond_with @events
  end

  def show
    @event = Event.find params[:id]
    authorize! :show, @event
    opengraph_data @event.to_opengraph
    respond_with @event
  end
end
