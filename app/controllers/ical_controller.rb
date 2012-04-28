class IcalController < ApplicationController

  def general
    response.headers["Content-Type"] = "text/calendar"

    events = SingleEvent.where(:occurrence => Date.today..(Date.today + 8.weeks))

    Gabba::Gabba.new("UA-954244-12", "hcking.de").event("Event", "iCal")
    render_events(events)
  end

  def personalized
    response.headers["Content-Type"] = "text/calendar"

    user = User.where(:guid => params[:guid]).first

    events = if user && !params[:guid].blank?
      user.single_events.where(:occurrence => Date.today..(Date.today + 8.weeks))
    else
      []
    end
    Gabba::Gabba.new("UA-954244-12", "hcking.de").event("Event", "iCal-personalized")
    render_events(events)
  end

  def like_welcome_page
    response.headers["Content-Type"] = "text/calendar"

    user = User.where(:guid => params[:guid]).first

    events = if user && !params[:guid].blank?
      SingleEvent.where(:occurrence => Date.today..(Date.today + 8.weeks)).delete_if do |single_event|
        (
          (single_event.event.tag_list & user.hate_list).length > 0 &&
          (!single_event.users.include? user)
        )
      end
    else
      []
    end

    Gabba::Gabba.new("UA-954244-12", "hcking.de").event("Event", "iCal-not-hated")
    render_events(events)
  end

  private

  def render_events(events)
    cal = RiCal.Calendar do |cal|
      events.each do |single_event|
        single_event.populate_event_for_rical(cal)
      end
    end
    render text: cal
  end

end
