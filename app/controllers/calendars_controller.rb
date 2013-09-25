#encoding: utf-8
class CalendarsController < ApplicationController

  def show
    @categories = Category.all

    # Die Monate, die angezeigt werden
    begin
      @start_date = params[:start].present? ? Date.parse(params[:start]) : Date.today
    rescue ArgumentError
      @start_date = Date.today
      flash.now[:error] = 'Das war kein gültiges Datum... Wir zeigen dir mal den Kalender ab heute'
    end

    @months = []
    13.times { |i| @months << (@start_date + i.months) }

    if current_region.nil?
      raise ActionController::RoutingError.new('Not Found')
    end

    @single_events = SingleEvent.in_next_from(4.weeks, @start_date).in_region(@region)
    @single_events.to_a.select! { |single_event| single_event.is_for_user? current_user } if current_user
    @single_events.sort!
  end

end
