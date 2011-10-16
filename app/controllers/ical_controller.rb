class IcalController < ApplicationController

  def index
    response.headers["Content-Type"] = "text/calendar"
    cal = RiCal.Calendar do
      SingleEvent.where(:occurrence => Date.today..(Date.today + 8.weeks)).each do |single_event|
        event do
          start_time = single_event.occurrence
          end_time  = (single_event.occurrence + (single_event.event.schedule.duration || 3600))

          if single_event.event.full_day
            start_time = start_time.to_date
            end_time = end_time.to_date
          else
            start_time = start_time.utc
            end_time = end_time.utc
          end
          loc = [single_event.event.location, single_event.event.address].delete_if{|d|d.blank?}.join(", ").strip

          summary     single_event.title
          description ActionController::Base.helpers.strip_tags("#{single_event.description}\n\n#{single_event.event.description}".strip)
          dtstart     start_time
          dtend       end_time
          location    loc unless loc.blank?
          url         Rails.application.routes.url_helpers.event_single_event_url(
                        :host => Rails.env.production? ? "hcking.de" : "hcking.dev",
                        :event_id => single_event.event.id, 
                        :id => single_event.id)
        end
      end
    end
    Gabba::Gabba.new("UA-954244-12", "hcking.de").event("Event", "iCal")
    render :text => cal
  end

end
