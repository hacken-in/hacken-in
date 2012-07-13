# encoding: utf-8

class Schedule::RulesController < ApplicationController

  def create
    @event = Event.find(params[:event_id])
    authorize! :update, @event

    day_of_week = params[:day_of_week].to_i
    week_number = params[:week_number].to_i
    rule = IceCube::Rule.monthly.day_of_week({
      Date::DAYNAMES[day_of_week].downcase.to_sym => [week_number]
    })
    @event.schedule.add_recurrence_rule rule

    if !@event.save
      redirect_to(@event, alert: 'Datum konnte nicht hinzugefügt werden.')
    else
      redirect_to(@event, notice: 'Datum hinzugefügt.')
    end
  end

  def destroy
    @event = Event.find(params[:event_id])
    authorize! :destroy, @event

    rule = @event.schedule.rrules[params[:id].to_i]
    @event.schedule.remove_recurrence_rule(rule)

    if !@event.save
      redirect_to(@event, alert: 'Datum konnte nicht entfernt werden.')
    else
      redirect_to(@event, notice: 'Datum entfernt.')
    end
  end

end
