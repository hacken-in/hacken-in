class SingleEventIcal
  extend Forwardable

  def_delegators :@single_event, :full_name, :description, :event, :occurrence, :duration, :venue, :full_day, :venue_info, :id

  def initialize(single_event)
    @single_event = single_event
  end

  def to_ical_event
    ical_event = Icalendar::Event.new
    ical_event.summary = full_name
    ical_event.description = ActionController::Base.helpers.strip_tags("#{description}\n\n#{event.description}".strip)

    start_time = occurrence
    end_time = (occurrence + (event.schedule.duration || 1.hour))

    if full_day
      ical_event.dtstart = start_time.to_date
      ical_event.dtend = end_time.to_date
    else
      ical_event.dtstart = start_time.to_datetime
      ical_event.dtend = (duration.nil? ? end_time : (start_time + duration.minutes)).to_datetime
    end

    if venue.present?
      location = [venue_info, venue.address].delete_if(&:blank?).join(", ").strip
    end

    ical_event.location = location if location.present?
    url = Rails.application.routes.url_helpers.event_single_event_url(
      host: Rails.env.production? ? "hacken.in" : "hacken.dev",
      event_id: event.id,
      id: id
    )
    ical_event.url = url
    ical_event
  end

  def self.to_icalendar(single_events)
    calendar = Icalendar::Calendar.new
    single_events.each do |e|
      calendar.add_event(self.new(e).to_ical_event)
    end
    calendar.to_ical
  end
end
