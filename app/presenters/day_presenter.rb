class DayPresenter
  attr_accessor :active

  def initialize(day)
    @day = day
    @active = false
  end

  def weekday
    @day[:weekday]
  end

  def day
    @day[:day]
  end

  def has_events
    @day[:has_events]
  end

  def css_class
    [
      (active ? "active" : false),
      (has_events ? "has_events" : false)
    ]
  end
end
