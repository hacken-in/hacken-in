class SingleEventIcal
  extend Forwardable

  def_delegators :@single_event, :full_name, :event, :occurrence, :duration, :venue, :full_day, :venue_info, :id
  attr_reader :single_event

  def initialize(single_event)
    @single_event = single_event
  end

  def self.to_icalendar(single_events)
    calendar = Icalendar::Calendar.new
    single_events.each do |e|
      calendar.add_event(new(e).to_ical_event)
    end
    calendar.to_ical
  end

  def to_ical_event
    ical_event = Icalendar::Event.new
    ical_event.summary = full_name
    ical_event.description = description
    ical_event.dtstart = dtstart
    ical_event.dtend = dtend
    ical_event.location = location if venue.present?
    ical_event.url = url
    ical_event
  end

  private

  def url
    Rails.application.routes.url_helpers.event_single_event_url(
      host: Rails.env.production? ? "hacken.in" : "hacken.dev",
      event_id: event.id,
      id: id
    )
  end

  def location
    [venue_info, venue.address].delete_if(&:blank?).join(", ").strip
  end

  def description
    ActionController::Base.helpers.strip_tags("#{single_event.description}\n\n#{event.description}".strip)
  end

  def dtstart
    full_day ? occurrence.to_date : occurrence.to_datetime
  end

  def dtend
    full_day ? end_time.to_date : end_time.to_datetime
  end

  def end_time
    if duration.nil?
      occurrence + (event.schedule.duration || 1.hour)
    else
      occurrence + duration.minutes
    end
  end
end
