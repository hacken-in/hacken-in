class DayPresenter
  attr_accessor :active
  attr_reader :has_events, :date

  def initialize(date, has_events)
    @date = date
    @has_events = has_events
    @active = false
  end

  def weekday
    I18n.localize(date, format: '%a')
  end

  def day
    date.day
  end

  def css_class
    [
      (active ? "active" : false),
      (has_events ? "has_events" : false)
    ]
  end

  def to_partial_path
    'modules/calendars/start_selector/day'
  end
end
