class CalendarsController < ApplicationController
  
  def show
    @categories = Category.all

    # Die Presets
    @presets = CalendarPreset.nerdhub_presets.all
    @presets_json = CalendarPreset.presets_for_user(current_user)
    
    # Die Monate, die angezeigt werden
    startdate = params[:start].present? ? Date.parse(params[:start]) : Date.today

    @months = []
    13.times { |i| @months << (startdate + i.months) }

    @single_events = SingleEvent.in_next(4.weeks) #.for_user(current_user)

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
    render :entries, layout: false
  end


  def presets
    @presets = CalendarPreset.presets_for_user(current_user)
    render json: @presets
  end

  def update_presets
    if current_user
      preset = CalendarPreset.find_or_create_by_user_id(current_user.id)
      begin
        preset.category_ids = params[:category_ids].split(',')
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Du willst eine Kategorie in deinen Kalender aufnehmen, die es nicht gibt ...' }
        return
      end

      if preset.save
        render json: { diy: preset.category_ids }
      else
        render json: { error: 'Could not save' }
      end
    end
  end
end
