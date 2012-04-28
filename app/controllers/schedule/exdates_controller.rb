# encoding: utf-8

require 'datetime_parser'

class Schedule::ExdatesController < ApplicationController
  include ::DatetimeParser

  def destroy
    @event = Event.find(params[:event_id])
    authorize! :destroy, @event

    exdate = @event.schedule.extimes[params[:id].to_i]
    @event.schedule.remove_exception_time(exdate)

    if !@event.save
      redirect_to(event_path(@event), :alert => 'Datum konnte nicht entfernt werden.')
    else
      redirect_to(event_path(@event), :notice => 'Datum entfernt.')
    end
  end

end
