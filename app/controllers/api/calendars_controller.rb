#encoding: utf-8
class Api::CalendarsController < ApplicationController
  layout false

  def show
    begin
      throw ArgumentError.new unless params[:from].present?
      from = Date.parse(params[:from])
    rescue ArgumentError
      render text: 'Die Anfangszeit ist kein valides Datum', status: 400
      return
    end

    begin
      throw ArgumentError.new unless params[:to].present?
      to = Date.parse(params[:to])
    rescue ArgumentError
      render text: 'Die Endzeit ist kein valides Datum', status: 400
      return
    end

    # Falls ein Datum angegeben wurde, dass vor dem Anfangsdatum liegt
    if to < from
      to = from + 4.weeks
    end

    if current_region.nil?
      render text: 'Die Region wurde nicht gefunden', status: 404
      return
    end

    @single_events = SingleEvent.where('? <= occurrence AND occurrence <= ?', from, to).in_region(current_region)
    @single_events = @single_events.in_categories(params[:categories].split(',').map(&:to_i)) unless params[:categories].blank?

    @single_events.to_a.select! { |single_event| single_event.is_for_user? current_user } if current_user
    @single_events.sort!

    render :entries
  end

end
