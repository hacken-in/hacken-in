#encoding: utf-8
class CalendarsController < ApplicationController

  def show
    @categories = Category.calendar.all

    # Die Presets
    @presets = CalendarPreset.nerdhub_presets.all
    @presets_json = CalendarPreset.presets_for_user(current_user)

    # Die Monate, die angezeigt werden
    begin
      @start_date = params[:start].present? ? Date.parse(params[:start]) : Date.today
    rescue ArgumentError => e
      @start_date = Date.today
      flash.now[:error] = 'Das war kein gültiges Datum... Wir zeigen dir mal den Kalender ab heute'
    end

    @months = []
    13.times { |i| @months << (@start_date + i.months) }

    @single_events = SingleEvent.in_next_from(4.weeks, @start_date) #.for_user(current_user)

  end

  def entries
    begin
      from = Date.parse(params[:from])
    rescue ArgumentError
      render text: 'Die Anfangszeit ist kein valides Datum', status: 400
      return
    end

    begin
      to = Date.parse(params[:to])
    rescue ArgumentError
      render text: 'Die Endzeit ist kein valides Datum', status: 400
      return
    end

    @single_events = SingleEvent.where('? <= occurrence AND occurrence <= ?', from, to)
    @single_events = @single_events.in_categories(params[:categories].split(',').map(&:to_i)) if params[:categories]

    # TODO: An dieser Stelle sollten eigentlich noch die Events nach den Tags rausgefilter werden
    # sowohl mit der alten Methode, wie auch mit der neuen (siehe SingleEvent#is_for_user?) dauert
    # das ca 6 Sekunden um 4 Wochen voller Termine zu filtern ... ähm ... da stimmt was nicht ...
    # Da solltet ihr auf jeden Fall mal drüber gucken ... Solange bleibt die Funktion mal auskommentiert
    #
    # Das Gleiche gilt auch in der show Methode ...

    #@single_events = @single_events.for_user(current_user)
    render :entries, layout: false
  end


  def presets
    @presets = CalendarPreset.presets_for_user(current_user)
    render json: @presets
  end

  def update_presets
    return render(:nothing => true, :status => :unauthorized) unless current_user

    preset = CalendarPreset.find_or_create_by_user_id(current_user.id)
    begin
      preset.category_ids = params[:category_ids].split(',').map(&:to_i)
    rescue ActiveRecord::RecordNotFound
      render json: { error: 'Du willst eine Kategorie in deinen Kalender aufnehmen, die es nicht gibt ...' }
      return
    end

    if preset.save
      render json: { status: 'success', diy: preset.category_ids }, :status => :ok
    else
      render json: { status: 'error', message: 'Could not save' }, :status => 422
    end
  end

end
