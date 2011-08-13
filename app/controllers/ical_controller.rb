class IcalController < ApplicationController
  caches_action :inde, :expires_in => 10.minutes

  def index
    response.headers["Content-Type"] = "text/calendar"
    cal = RiCal.Calendar do
      Event.get_ordered_events(Date.today, Date.today + 8.weeks).each do |entry|
        event do

          start_time = entry[:time]
          end_time  = (entry[:time] + (entry[:event].schedule.duration || 3600))

          if entry[:event].full_day
            start_time = start_time.to_date
            end_time = end_time.to_date
          else
            start_time = start_time.utc
            end_time = end_time.utc
          end
          loc = [entry[:event].location, entry[:event].address].delete_if{|d|d.blank?}.join(", ").strip

          summary     entry[:event].name
          description ActionController::Base.helpers.strip_tags(entry[:event].description || "")
          dtstart     start_time
          dtend       end_time
          location    loc unless loc.blank?
          url         entry[:event].url if !entry[:event].url.blank?
        end
      end
    end
    Gabba::Gabba.new("UA-954244-12", "wood.hcking.de").event("Event", "iCal")
    render :text => cal
  end

end
