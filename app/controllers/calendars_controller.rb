#encoding: utf-8
class CalendarsController < ApplicationController
  before_action :require_region!, only: [ :show ]

  def show
    @start_selector = StartSelector.new(start_date)
    @calendar       = Calendar.new(start_date, current_region, current_user)
  end

  private

  def start_date
    @start_date ||= params[:start].present? ? Date.parse(params[:start]) : Date.today
  end
end
