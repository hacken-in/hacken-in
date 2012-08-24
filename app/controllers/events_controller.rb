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

  def new
    @event = Event.new
    authorize! :new, @event
    respond_with @event
  end

  def edit
    @event = Event.find params[:id]
    authorize! :edit, @event
    respond_with @event
  end

  def create
    @event = Event.new filtered_params(params[:event])
    @event.start_time = determine_start_time_for_event params[:event]
    authorize! :create, @event

    if @event.save
      flash[:notice] = t "events.create.confirmation"
    end

    respond_with @event
  end

  def update
    @event = Event.find params[:id]
    @event.start_time = determine_start_time_for_event params[:event]
    authorize! :update, @event

    if @event.update_attributes filtered_params(params[:event])
      expire_fragment "event_occurences_#{@event.id}"
      flash[:notice] = t "events.update.confirmation"
    end

    respond_with @event
  end

  def destroy
    @event = Event.find params[:id]
    authorize! :destroy, @event

    if @event.destroy
      flash[:notice] = t "events.destroy.confirmation"
    end

    respond_with @product, location: root_path
  end

  def history
    authorize! :index, Event
    @events = SingleEvent.where("occurrence < ?", Time.now.at_beginning_of_day)
    respond_with @events
  end

  private

  def determine_start_time_for_event(event)
    if event["start_time(1i)"]
      start_time = Time.new event["start_time(1i)"].to_i,
                            event["start_time(2i)"].to_i,
                            event["start_time(3i)"].to_i,
                            event["start_time(4i)"].to_i,
                            event["start_time(5i)"].to_i
    end

    start_time || Time.now
  end

  def filtered_params(params)
    params.except "start_time(1i)",
                  "start_time(2i)",
                  "start_time(3i)",
                  "start_time(4i)",
                  "start_time(5i)"
  end
end
