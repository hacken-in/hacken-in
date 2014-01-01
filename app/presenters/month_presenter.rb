class MonthPresenter
  attr_accessor :active

  def initialize(month)
    @month = month
  end

  def year
    @month.strftime('%Y')
  end

  def month
    @month.month
  end

  def data
    { year: year, month: month }
  end

  def to_s
    I18n.localize(@month, format: '%b')
  end

  def css_class
    active ? 'active' : 'inactive'
  end

  def to_partial_path
    'modules/calendars/start_selector/month'
  end
end
