class EventsController < ApplicationController

  def index
    authorize! :index, Event
    @events = Event.order :name
  end

  def show
    @event = Event.find params[:id]
    authorize! :show, @event
    opengraph_data @event.to_opengraph

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render xml: @event }
    end
  end

  def new
    @event = Event.new
    authorize! :new, @event

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render xml: @event }
    end
  end

  def edit
    @event = Event.find params[:id]
    authorize! :edit, @event
  end

  def create
    ical_url = params[:event]["ical_url"]
    @event = Event.new filtered_params(params[:event])

    @event.start_time = determine_start_time_for_event params[:event]
    @event.ical_file  = determine_ical_file_according_to_url ical_url unless ical_url.blank?

    authorize! :create, @event

    respond_to do |format|
      if @event.save
        format.html { redirect_to(@event, notice: 'Event angelegt.') }
        format.xml  { render xml: @event, status: :created, location: @event }
      else
        format.html { render action: "new" }
        format.xml  { render xml: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    @event = Event.find params[:id]
    authorize! :update, @event

    respond_to do |format|
      @event.start_time = determine_start_time_for_event params[:event]

      if @event.update_attributes filtered_params(params[:event])
        expire_fragment "event_occurences_#{@event.id}"
        format.html { redirect_to(@event, notice: 'Event aktualisiert') }
        format.xml  { head :ok }
      else
        format.html { render action: "edit" }
        format.xml  { render xml: @event.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @event = Event.find params[:id]
    authorize! :destroy, @event
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(root_path) }
      format.xml  { head :ok }
    end
  end

  private

  def determine_start_time_for_event(event)
    start_time = Time.new(event["start_time(1i)"].to_i,
                                         event["start_time(2i)"].to_i,
                                         event["start_time(3i)"].to_i,
                                         event["start_time(4i)"].to_i,
                                         event["start_time(5i)"].to_i) if event["start_time(1i)"]

    start_time || Time.now
  end

  def determine_ical_file_according_to_url(url)
    ical_file = IcalFile.where "url = ?", url

    if ical_file.blank?
      ical_file = IcalFile.create url: url 
    else
      ical_file = ical_file.first
    end
    
    ical_file
  end

  def filtered_params(params)
    params.except "start_time(1i)", "start_time(2i)", "start_time(3i)", "start_time(4i)", "start_time(5i)", "ical_url"
  end
end