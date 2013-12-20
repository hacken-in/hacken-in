#encoding: utf-8
class CalendarsController < ApplicationController

  def show
    raise ActionController::RoutingError.new('Not Found') if current_region.nil?

    @categories    = Category.all
    @start_date    = determine_start_date
    @months        = generate_month_list(@start_date, 8)
    @dates         = generate_day_list(@start_date, 5)
    @single_events = generate_single_event_list(@start_date, 4)
  end

  private

  def determine_start_date
    params[:start].present? ? Date.parse(params[:start]) : Date.today
  rescue ArgumentError
    Date.today
  end

  def generate_month_list(start_date, number_of_months)
    months = (0..number_of_months).map { |i| MonthPresenter.new(start_date + i.months) }
    months.first.active = true
    months
  end

  def generate_day_list(start_date, number_of_days)
    date_range = start_date .. start_date + number_of_days.days

    days = SingleEvent.events_per_day_in(date_range).sort.map do |day, occurrences|
      DayPresenter.new(day, (occurrences > 0))
    end
    days.first.active = true
    days
  end

  def generate_single_event_list(start_date, number_of_weeks)
    single_events = SingleEvent.in_next_from(number_of_weeks.weeks, start_date).in_region(@region)
    single_events.to_a.select! { |single_event| single_event.is_for_user? current_user } if current_user
    single_events.sort
  end
end
