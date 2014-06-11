#encoding: utf-8
class Api::CalendarsController < ApplicationController
  layout false

  def entries
    @calendar = Calendar.new(start_date, current_region, current_user)
  end

  def selector
    @start_selector = StartSelector.new(start_date)
  end

  private

  def start_date
    if params[:start].present?
      Date.parse(params[:start])
    else
      Date.today
    end
  end

end
