#encoding: utf-8
class CalendarsController < ApplicationController

  def show
    raise ActionController::RoutingError.new('Not Found') if current_region.nil?

    @categories     = Category.all
    @start_selector = StartSelector.new(start_date, 8, 5)
    @calendar       = generate_calendar(start_date, 4)
  end

  private

  def start_date
    @start_date ||= begin
      Date.parse(params[:start])
    rescue ArgumentError, TypeError
      Date.today
    end
  end

  def generate_calendar(start_date, number_of_weeks)
    single_events = SingleEvent.in_next_from(number_of_weeks.weeks, start_date).in_region(@region)
    Calendar.new(single_events, current_user)
  end
end
