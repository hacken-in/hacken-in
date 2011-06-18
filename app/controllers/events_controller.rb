class EventsController < ApplicationController

  def index
    if !can? :update, Event
      redirect_to root_path
    end
  end

  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  def new
    @event = Event.new
    authorize! :create, Event

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  def edit
    @event = Event.find(params[:id])
    authorize! :update, @event
  end

  def create
    authorize! :create, Event
    @event = Event.new(params[:event])
 
    respond_to do |format|
      if @event.save
        format.html { redirect_to(@event, :notice => 'Event angelegt.') }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @event = Event.find(params[:id])
    authorize! :update, @event

    respond_to do |format|
      if @event.update_attributes(params[:event])
        format.html { redirect_to(@event, :notice => 'Event aktualisiert') }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @event = Event.find(params[:id])
    authorize! :destroy, @event

    @event.destroy

    respond_to do |format|
      format.html { redirect_to(root_path) }
      format.xml  { head :ok }
    end
  end

  def ical
    response.headers["Content-Type"] = "text/calendar"
    cal = RiCal.Calendar do
      Event.get_ordered_events(Date.today, Date.today + 8.weeks).each do |entry|
        event do
          summary     entry[:event].name
          description (entry[:event].description || "")
          dtstart     entry[:time].utc
          dtend       (entry[:time] + (entry[:event].schedule.duration || 3600)).utc
          location    (entry[:event].address || "")
        end
      end
    end
    Gabba::Gabba.new("UA-954244-12", "wood.hcking.de").event("Event", "iCal")
    render :text => cal
  end

end
