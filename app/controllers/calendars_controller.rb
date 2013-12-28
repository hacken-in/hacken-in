#encoding: utf-8
class CalendarsController < ApplicationController

  def show
    raise ActionController::RoutingError.new('Not Found') if current_region.nil?

    @start_selector = StartSelector.new(start_date)
    @calendar       = Calendar.new(start_date, current_region, current_user)
  end

  private

  def start_date
    @start_date ||= params[:start].present? ? Date.parse(params[:start]) : Date.today
  end
end
