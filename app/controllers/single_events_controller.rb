class SingleEventsController < ApplicationController
  def show
    @single_event = SingleEvent.find(params[:id])
    @event = @single_event.event
  end

  def edit
  end

  def update
  end

end
