# encoding: utf-8

class SingleEventsController < ApplicationController
  respond_to :html, :xml

  def new
    @event = Event.find params[:event_id]
    @single_event = @event.single_events.new based_on_rule: false
    @single_event.occurrence = 2.days.from_now.beginning_of_day + 20.hours
    authorize! :new, @single_event
    respond_with @single_event
  end

  def create
    @event = Event.find params[:event_id]
    @single_event = @event.single_events.create params[:single_event]
    authorize! :create, @single_event

    if @event.save
      flash[:notice] = t "single_events.create.confirmation"
    end

    respond_with @single_event, location: @event
  end

  def show
    @single_event = SingleEvent.find params[:id]
    opengraph_data @single_event.to_opengraph
    @event = @single_event.event
    respond_with @single_event
  end

  def edit
    @event = Event.find params[:event_id]
    @single_event = SingleEvent.find params[:id]
    authorize! :edit, @single_event
    respond_with @single_event
  end

  def update
    @single_event = SingleEvent.find params[:id]
    authorize! :update, @single_event
    @single_event.update_attributes params[:single_event]

    if @single_event.save
      flash[:notice] = t "single_events.update.confirmation"
    end

    respond_with @single_event,
      location: event_single_event_path(@single_event.event, @single_event)
  end

  def destroy
    @single_event = SingleEvent.find params[:id]
    authorize! :destroy, @single_event

    if @single_event.destroy
      flash[:notice] = t "single_events.destroy.confirmation"
    end

    respond_with @single_event, location: @single_event.event
  end

  def participate
    change_participation params[:id],
      :push,
      t("single_events.participate.confirmation")
  end

  def unparticipate
    change_participation params[:id],
      :delete,
      t("single_events.unparticipate.confirmation")
  end

  private

  def change_participation(id, how, confirmation)
    @single_event = SingleEvent.find id

    if user_signed_in?
      @single_event.users.send how, current_user
      flash[:notice] = confirmation
    else
      flash[:error] = t "devise.failure.unauthenticated"
    end

    respond_with @single_event,
      location: event_single_event_path(@single_event.event, @single_event)
  end
end
