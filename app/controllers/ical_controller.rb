class IcalController < ApplicationController

  def general
    set_calendar_headers

    events = SingleEvent.where(occurrence: Date.today..(Date.today + 8.weeks))

    Gabba::Gabba.new("UA-954244-12", "hcking.de").event("Event", "iCal") if Rails.env.production?
    render_events(events)
  end

  def personalized
    set_calendar_headers
    
    user = User.where(guid: params[:guid]).first

    events = if user && !params[:guid].blank?
      user.single_events.where(occurrence: Date.today..(Date.today + 8.weeks))
    else
      []
    end
    Gabba::Gabba.new("UA-954244-12", "hcking.de").event("Event", "iCal-personalized") if Rails.env.production?
    render_events(events)
  end

  def like_welcome_page
    set_calendar_headers

    user = User.where(guid: params[:guid]).first

    events = if user && !params[:guid].blank?
      SingleEvent.where(occurrence: Date.today..(Date.today + 8.weeks)).delete_if do |single_event|
        (
          (single_event.event.tag_list & user.hate_list).length > 0 &&
          (!single_event.users.include? user)
        )
      end
    else
      []
    end

    Gabba::Gabba.new("UA-954244-12", "hcking.de").event("Event", "iCal-not-hated") if Rails.env.production?
    render_events(events)
  end
  
  def for_single_event
    set_calendar_headers
    
    begin
      single_event = SingleEvent.find(params[:id])
      render_events [single_event]
      
    rescue ActiveRecord::RecordNotFound
      render_events []
    end
  end
  
  def for_event
    set_calendar_headers
    
    begin
      event = Event.find(params[:id])
      render_events event.single_events
      
    rescue ActiveRecord::RecordNotFound
      render_events []
    end
  end

  def for_tag
    set_calendar_headers
    
    begin
      render_events SingleEvent.by_tag(params[:id])
    rescue ActiveRecord::RecordNotFound
      render_events []
    end
  end

  private

  def set_calendar_headers
    response.headers["Content-Type"] = "text/calendar; charset=UTF-8"
  end

  def render_events(events)
    cal = RiCal.Calendar do |cal|
      events.each do |single_event|
        single_event.populate_event_for_rical(cal)
      end
    end
    render text: cal
  end

end
