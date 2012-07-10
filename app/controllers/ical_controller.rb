class IcalController < ApplicationController
  before_filter :set_calendar_headers
  before_filter :gabba, only: [:general, :personalized, :like_welcome_page], if: ->{ Rails.env.production? }

  def general
    events = SingleEvent.where(occurrence: Date.today..(Date.today + 8.weeks))
    render_events(events)
  end

  def personalized
    user = User.where(guid: params[:guid]).first

    events = if user && !params[:guid].blank?
      user.single_events.where(occurrence: Date.today..(Date.today + 8.weeks))
    else
      []
    end
    render_events(events)
  end

  def like_welcome_page
    user = User.where(guid: params[:guid]).first

    events = if user && !params[:guid].blank?
      SingleEvent.where(occurrence: Date.today..(Date.today + 8.weeks)).delete_if do |single_event|
        (
          (single_event.event.tag_list & user.hate_list).length > 0 &&
          (!single_event.users.include? user)
        )
      end
    else
      []
    end
    render_events(events)
  end

  def for_single_event
    begin
      single_event = SingleEvent.find(params[:id])
      render_events [single_event]

    rescue ActiveRecord::RecordNotFound
      render_events []
    end
  end

  def for_event
    begin
      event = Event.find(params[:id])
      render_events event.single_events

    rescue ActiveRecord::RecordNotFound
      render_events []
    end
  end

  def for_tag
    begin
      render_events SingleEvent.only_tagged_with params[:id]
    rescue ActiveRecord::RecordNotFound
      render_events []
    end
  end

  private

  def set_calendar_headers
    response.headers["Content-Type"] = "text/calendar; charset=UTF-8"
  end

  def render_events(events)
    cal = RiCal.Calendar do |cal|
      events.each do |single_event|
        single_event.populate_event_for_rical(cal)
      end
    end
    render text: cal
  end

  def gabba
    key = case params[:action]
    when "general" then "iCal"
    when "personalized" then "iCal-personalized"
    when "like_welcome_page" then "iCal-not-hated"
    end
    Gabba::Gabba.new("UA-954244-12", "hcking.de").event("Event", key)
  end

end
