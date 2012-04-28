# encoding: utf-8

require 'datetime_parser'

class Schedule::RdatesController < ApplicationController
  include DatetimeParser

  def destroy
    @event = Event.find(params[:event_id])
    authorize! :destroy, @event

    rdate = @event.schedule.rtimes[params[:id].to_i]
    @event.schedule.remove_recurrence_time(rdate)

    if !@event.save
      redirect_to(@event, alert: 'Datum konnte nicht entfernt werden.')
    else
      redirect_to(@event, notice: 'Datum entfernt.')
    end
  end

end
