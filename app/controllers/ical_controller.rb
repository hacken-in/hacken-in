class IcalController < ApplicationController
  caches_action :inde, :expires_in => 10.minutes

  def index
    response.headers["Content-Type"] = "text/calendar"
    cal = RiCal.Calendar do
      Event.get_ordered_events(Date.today, Date.today + 8.weeks).each do |entry|
        event do
          summary     entry[:event].name
          description ActionController::Base.helpers.strip_tags(entry[:event].description || "")
          dtstart     entry[:time].utc
          dtend       (entry[:time] + (entry[:event].schedule.duration || 3600)).utc
          location    (entry[:event].address || "")
          url         entry[:event].url if !entry[:event].url.blank?
        end
      end
    end
    Gabba::Gabba.new("UA-954244-12", "wood.hcking.de").event("Event", "iCal")
    render :text => cal
  end

end
