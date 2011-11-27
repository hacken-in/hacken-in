class IcalController < ApplicationController

  def general
    response.headers["Content-Type"] = "text/calendar"

    cal = RiCal.Calendar do |cal|
      SingleEvent.where(:occurrence => Date.today..(Date.today + 8.weeks)).each do |single_event|
        single_event.populate_event_for_rical(cal)
      end
    end

    Gabba::Gabba.new("UA-954244-12", "hcking.de").event("Event", "iCal")
    render :text => cal
  end

  def personalized
    response.headers["Content-Type"] = "text/calendar"

    user = User.where(:guid => params[:guid]).first

    cal = RiCal.Calendar do |cal|
      user.single_events.where(:occurrence => Date.today..(Date.today + 8.weeks)).each do |single_event|
        single_event.populate_event_for_rical(cal)
      end
    end

    Gabba::Gabba.new("UA-954244-12", "hcking.de").event("Event", "iCal")
    render :text => cal
  end
end
