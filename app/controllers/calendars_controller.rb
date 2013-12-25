#encoding: utf-8
class CalendarsController < ApplicationController

  def show
    raise ActionController::RoutingError.new('Not Found') if current_region.nil?

    @start_selector = StartSelector.new(start_date)
    single_events   = SingleEvent.in_next_from(4.weeks, start_date).in_region(current_region)
    @calendar       = Calendar.new(single_events, current_user)
  end

  private

  def start_date
    @start_date ||= begin
      Date.parse(params[:start])
    rescue ArgumentError, TypeError
      Date.today
    end
  end
end
