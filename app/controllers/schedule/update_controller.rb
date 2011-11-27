# encoding: utf-8

require 'datetime_parser'

class Schedule::UpdateController < ApplicationController
  include DatetimeParser

  def update
    @event = Event.find(params[:event_id])
    authorize! :update, @event

    @event.schedule.start_date = parse_datetime_select(params[:start_date], "date")

    @event.schedule.start_date = @event.schedule.start_date.beginning_of_day if @event.full_day

    @event.schedule.duration = params[:duration].to_i * 60

    if !@event.save
      redirect_to(@event, :alert => 'Event konnte nicht geändert werden.')
    else
      redirect_to(@event, :notice => 'Event geändert.')
    end
  end

end
