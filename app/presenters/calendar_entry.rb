class CalendarEntry
  def initialize(single_event)
    @single_event = single_event
    @event = @single_event.event
    @venue = @single_event.venue
  end

  def title
    @event.name
  end

  # TODO: The subtitle could be empty
  def subtitle
    @single_event.name
  end

  def additional_info
    additional_info = []
    additional_info << formated_location if @venue.present?
    additional_info << formated_door_time unless @single_event.full_day
    additional_info.join(", ")
  end

  def path_info
    [@single_event.event, @single_event]
  end

  def color
    @single_event.category.try(:color)
  end

  def to_partial_path
    'modules/calendars/entry'
  end

  def start_date
    I18n.localize(@single_event.occurrence, format: "%C-%m-%d")
  end

  private

  def formated_location
    "<span itemprop='location'>" +
      "#{@single_event.venue.city}, #{@single_event.venue.location}, #{@single_event.venue.street}" +
      "</span>"
  end

  def formated_door_time
    "<span itemprop='doorTime' content='#{door_time}'>" +
      start_time +
      "</span>"
  end

  def start_time
    I18n.localize(@single_event.occurrence, format: "%H:%M")
  end

  def door_time
    I18n.localize(@single_event.occurrence, format: "%Y-%m-%dT%k:%M:%S")
  end
end
