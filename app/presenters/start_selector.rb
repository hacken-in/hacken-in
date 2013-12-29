class StartSelector
  NUMBER_OF_MONTHS = 20
  NUMBER_OF_DAYS = 20

  def initialize(start_date)
    @start_date = start_date
  end

  def months
    months = (0...NUMBER_OF_MONTHS).map { |i| MonthPresenter.new(@start_date + i.months) }
    months.first.active = true
    months
  end

  def days
    date_range = @start_date ... @start_date + NUMBER_OF_DAYS.days

    days = SingleEvent.events_per_day_in(date_range).sort.map do |day, occurrences|
      DayPresenter.new(day, (occurrences > 0))
    end
    days.first.active = true
    days
  end
end
