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

  def to_date
    Date.new(year.to_i, month.to_i, 1)
  end

  def css_class
    [
      (active ? 'active' : 'inactive'),
      (to_date == Date.today.beginning_of_month ? "today" : false)
    ]
  end

  def to_partial_path
    'modules/calendars/start_selector/month'
  end
end
