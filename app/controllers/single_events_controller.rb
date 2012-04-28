# encoding: utf-8

class SingleEventsController < ApplicationController
  def show
    @single_event = SingleEvent.find(params[:id])
    opengraph_data(@single_event.to_opengraph)

    @event = @single_event.event
  end

  def edit
    @single_event = SingleEvent.find(params[:id])
    authorize! :edit, @single_event
  end

  def update
    @single_event = SingleEvent.find(params[:id])
    authorize! :update, @single_event

    @single_event.update_attributes(params[:single_event])

    if @single_event.save
      flash[:notice] = t "single_events.save.confirmation"
    else
      flash[:error] = t "single_events.save.error"
    end

    redirect_to method: "show", event_id: @single_event.event.id, id: @single_event.id
  end

  def destroy
    @single_event = SingleEvent.find(params[:id])
    authorize! :destroy, @single_event
    @single_event.destroy
    redirect_to event_path(@single_event.event)
  end

  def participate
    @single_event = SingleEvent.find(params[:id])
    if user_signed_in?
      @single_event.users << current_user
      flash[:notice] = t "single_events.participate.confirmation"
    else
      flash[:error] = t "devise.failure.unauthenticated"
    end

    redirect_to event_single_event_path(@single_event.event,@single_event)
  end

  def unparticipate
    @single_event = SingleEvent.find(params[:id])
    if user_signed_in?
      @single_event.users.delete current_user
      flash[:notice] = t "single_events.unparticipate.confirmation"
    else
      flash[:error] = t "devise.failure.unauthenticated"
    end

    redirect_to event_single_event_path(@single_event.event,@single_event)
  end

end
