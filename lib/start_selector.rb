class StartSelector
  def initialize(start_date, number_of_months, number_of_days)
    @start_date = start_date
    @number_of_months = number_of_months
    @number_of_days = number_of_days
  end

  def months
    months = (0..@number_of_months).map { |i| MonthPresenter.new(@start_date + i.months) }
    months.first.active = true
    months
  end

  def dates
    date_range = @start_date .. @start_date + @number_of_days.days

    days = SingleEvent.events_per_day_in(date_range).sort.map do |day, occurrences|
      DayPresenter.new(day, (occurrences > 0))
    end
    days.first.active = true
    days
  end
end
