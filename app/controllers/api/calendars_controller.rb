#encoding: utf-8
class Api::CalendarsController < ApplicationController
  layout false

  def entries
    start_date = if params[:start].present?
                   Date.parse(params[:start])
                 else
                   Date.today
                 end

    @calendar = Calendar.new(start_date, current_region, current_user)
  end

  def selector
    start_date = if params[:start].present?
                   Date.parse(params[:start])
                 else
                   Date.today
                 end
    @start_selector = StartSelector.new(start_date)
  end

end
