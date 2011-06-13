class EventsController < ApplicationController

  def show
    @event = Event.find_by_id(params[:id])
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
    render :text => cal
  end

end
