class CalendarsController < ApplicationController
  
  def show
    @categories = Category.all
    
    # Die Monate, die angezeigt werden
    startdate = params[:start].present? ? Date.parse(params[:start]) : Date.today

    @months = []
    13.times { |i| @months << (startdate + i.months) }

    @events = SingleEvent.in_next(4.weeks).for_user(current_user)

  end

  def presets
    @presets = CalendarPreset.presets_for_user(current_user)
    render json: @presets
  end
end
