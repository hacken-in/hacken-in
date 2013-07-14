# encoding: utf-8

class SingleEventsController < ApplicationController
  respond_to :html, :xml

  def show
    @single_event = SingleEvent.find params[:id]
    opengraph_data @single_event.to_opengraph
    @event = @single_event.event
    @region = @event.region
    respond_with @single_event
  end
end
