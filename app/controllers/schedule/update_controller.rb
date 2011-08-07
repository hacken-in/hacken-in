# encoding: utf-8

require 'datetime_parser'

class Schedule::UpdateController < ApplicationController
  include DatetimeParser
  cache_sweeper :event_sweeper

  def update
    @event = Event.find(params[:event_id])
    authorize! :update, @event

    hash = @event.schedule.to_hash
    start_date = parse_datetime_select(params[:start_date], "date")
    hash[:duration] = params[:duration].to_i * 60
    @event.schedule = IceCube::Schedule.from_hash(hash,
                                    :start_date_override => start_date)

    if !@event.save
      redirect_to(@event, :alert => 'Event konnte nicht geändert werden.')
    else
      redirect_to(@event, :notice => 'Event geändert.')
    end
  end

end
