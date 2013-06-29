#encoding: utf-8
class CalendarsController < ApplicationController

  def show
    @categories = Category.all

    # Die Presets
    @presets = CalendarPreset.hacken_presets.all
    @presets_json = CalendarPreset.presets_for_user(current_user)

    # Die Monate, die angezeigt werden
    begin
      @start_date = params[:start].present? ? Date.parse(params[:start]) : Date.today
    rescue ArgumentError => e
      @start_date = Date.today
      flash.now[:error] = 'Das war kein gültiges Datum... Wir zeigen dir mal den Kalender ab heute'
    end

    @months = []
    13.times { |i| @months << (@start_date + i.months) }

    @single_events = SingleEvent.in_next_from(4.weeks, @start_date).in_categories(@presets_json[:diy])
    @single_events.select! { |single_event| single_event.is_for_user? current_user } if current_user
    @single_events.sort!
  end

end
