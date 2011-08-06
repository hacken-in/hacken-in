# encoding: utf-8

require 'datetime_parser'

class Schedule::RdatesController < ApplicationController
  include DatetimeParser
  cache_sweeper :event_sweeper

  def create
    @event = Event.find(params[:event_id])
    authorize! :update, @event

    rdate = parse_datetime_select(params[:rdate], "date")
    @event.schedule.add_recurrence_date(rdate)
    if !@event.save
      redirect_to(@event, :alert => 'Datum konnte nicht hinzugefügt werden.')
    else 
      redirect_to(@event, :notice => 'Datum hinzugefügt.')
    end
  end

  def destroy
    @event = Event.find(params[:event_id])
    authorize! :update, @event

    rdate = @event.schedule.rdates[params[:id].to_i]
    @event.schedule.remove_recurrence_date(rdate)

    if !@event.save
      redirect_to(@event, :alert => 'Datum konnte nicht entfernt werden.')
    else
      redirect_to(@event, :notice => 'Datum entfernt.')
    end
  end

end
