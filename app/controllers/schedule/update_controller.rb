# encoding: utf-8

require 'datetime_parser'

class Schedule::UpdateController < ApplicationController
  include DatetimeParser

  def update
    @event = Event.find(params[:event_id])
    authorize! :update, @event

    @event.update_start_time_and_duration(parse_datetime_select(params[:start_time], "date"), params[:duration])

    if !@event.save
      redirect_to(@event, :alert => 'Event konnte nicht geändert werden.')
    else
      redirect_to(@event, :notice => 'Event geändert.')
    end
  end

end
