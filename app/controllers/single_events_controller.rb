# encoding: utf-8

class SingleEventsController < ApplicationController

  def new
    @event = Event.find(params[:event_id])
    @single_event = @event.single_events.new
    @single_event.based_on_rule = false
    @single_event.occurrence = 2.days.from_now.beginning_of_day + 20.hours
    authorize! :new, @single_event
  end

  def create
    @event = Event.find(params[:event_id])
    @single_event = @event.single_events.create(params[:single_event])
    authorize! :create, @single_event

    respond_to do |format|
      if @single_event.save
        format.html { redirect_to(@event, notice: 'Termin angelegt.') }
        format.xml  { render xml: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.xml  { render xml: @single_event.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
    @single_event = SingleEvent.find(params[:id])
    opengraph_data(@single_event.to_opengraph)

    @event = @single_event.event
  end

  def edit
    @event = Event.find(params[:event_id])
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
