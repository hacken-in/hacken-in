# encoding: utf-8

class SingleEventsController < ApplicationController
  respond_to :html, :xml

  def show
    @advertisement = Advertisement.single_event
    @single_event = SingleEvent.find params[:id]
    opengraph_data @single_event.to_opengraph
    @event = @single_event.event
    respond_with @single_event
  end
end
