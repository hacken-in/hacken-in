#encoding: utf-8
class CalendarsController < ApplicationController
  before_action :require_region!, only: [ :show ]

  def index
  end

  def show
    start_date = params[:start].present? ? Date.parse(params[:start]) : Date.today

    @start_selector = StartSelector.new(start_date)
    @calendar       = Calendar.new(start_date, current_region, current_user)
  end
end
