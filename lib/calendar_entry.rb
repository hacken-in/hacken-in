require 'forwardable'

class CalendarEntry
  extend Forwardable

  def_delegators :@single_event, :title

  def initialize(single_event)
    @single_event = single_event
    @venue = @single_event.venue
  end

  # TODO: Implement
  def subtitle
    "I will be the subtitle"
  end

  def additional_info
    additional_info = []
    additional_info << "#{@single_event.venue.city}, #{@single_event.venue.location}, #{@single_event.venue.street}" if @venue.present?
    additional_info << I18n.localize(@single_event.occurrence, format: "%H:%M") unless @single_event.full_day
    additional_info.join(", ")
  end

  def path_info
    [@single_event.event, @single_event]
  end

  def color
    @single_event.category.try(:color)
  end
end
