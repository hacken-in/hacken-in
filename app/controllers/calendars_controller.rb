#encoding: utf-8
class CalendarsController < ApplicationController

  def show
    raise ActionController::RoutingError.new('Not Found') if current_region.nil?

    @categories    = Category.all
    @start_date    = determine_start_date
    @months        = generate_month_list
    @dates         = generate_day_list
    @single_events = generate_single_event_list
  end

  private

  def determine_start_date
    params[:start].present? ? Date.parse(params[:start]) : Date.today
  rescue ArgumentError
    Date.today
  end

  def generate_month_list
    months = (0..8).map { |i| MonthPresenter.new(@start_date + i.months) }
    months.first.active = true
    months
  end

  # TODO: This is just for the design, needs to be implemented for real
  def generate_day_list
    dates = (Date.today .. 5.days.from_now).map do |date|
      DayPresenter.new({
        weekday: date.strftime("%A")[0,2],
        day: date.day,
        has_events: (rand < 0.6)
      })
    end
    dates.first.active = true
    dates
  end

  def generate_single_event_list
    single_events = SingleEvent.in_next_from(4.weeks, @start_date).in_region(@region)
    single_events.to_a.select! { |single_event| single_event.is_for_user? current_user } if current_user
    single_events.sort
  end
end
