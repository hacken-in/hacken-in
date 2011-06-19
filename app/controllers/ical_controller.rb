class IcalController < ApplicationController

  def index
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
