class EventsController < ApplicationController

  def index
    authorize! :index, Event
  end

  def show
    @event = Event.find(params[:id])
    authorize! :show, @event

    opengraph_data(@event.to_opengraph)

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  def new
    @event = Event.new
    authorize! :new, @event

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  def edit
    @event = Event.find(params[:id])
    authorize! :edit, @event
  end

  def create
    @event = Event.new(params[:event])
    authorize! :create, @event

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
      @event.start_time = Time.new(params[:event]["start_time(1i)"].to_i,
                                         params[:event]["start_time(2i)"].to_i,
                                         params[:event]["start_time(3i)"].to_i,
                                         params[:event]["start_time(4i)"].to_i,
                                         params[:event]["start_time(5i)"].to_i) if params[:event]["start_time(1i)"]

      event_params = params[:event].except("start_time(1i)", "start_time(2i)", "start_time(3i)", "start_time(4i)", "start_time(5i)")

      if @event.update_attributes(event_params)
        expire_fragment("event_occurences_#{@event.id}")
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

end
