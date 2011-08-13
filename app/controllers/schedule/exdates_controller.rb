# encoding: utf-8

require 'datetime_parser'

class Schedule::ExdatesController < ApplicationController
  include ::DatetimeParser
  cache_sweeper :event_sweeper

  def create
    @event = Event.find(params[:event_id])
    authorize! :update, @event

    exdate = parse_datetime_select(params[:exdate], "date")    
    @event.schedule.add_exception_date(exdate)
    if !@event.save
      redirect_to(event_path(@event), :alert => 'Datum konnte nicht hinzugefügt werden.')
    else
      redirect_to(event_path(@event), :notice => 'Datum hinzugefügt.')
    end
  end

  def destroy
    @event = Event.find(params[:event_id])
    authorize! :update, @event

    exdate = @event.schedule.exdates[params[:id].to_i]
    @event.schedule.remove_exception_date(exdate)

    if !@event.save
      redirect_to(event_path(@event), :alert => 'Datum konnte nicht entfernt werden.')
    else
      redirect_to(event_path(@event), :notice => 'Datum entfernt.')
    end
  end

end
