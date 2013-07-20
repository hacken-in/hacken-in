class IcalController < ApplicationController
  GABBA_MAPPING = {
    general: "iCal",
    personalized: "iCal-personalized",
    like_welcome_page: "iCal-not-hated"
  }

  before_filter :set_calendar_headers
  before_filter :gabba, only: GABBA_MAPPING.keys if Rails.env.production?
  rescue_from ActiveRecord::RecordNotFound, with: :render_empty

  def general
    render_events SingleEvent.in_region(current_region).recent_to_soon(3.months)
  end

  def personalized
    render_events user.single_events.recent_to_soon(3.months)
  end

  def like_welcome_page
    @single_events = SingleEvent.recent_to_soon(3.months).in_region(current_region)
    @single_events.select! { |single_event| single_event.is_for_user? user }
    render_events @single_events
  end

  def for_single_event
    render_events SingleEvent.find(params[:id])
  end

  def for_event
    render_events Event.find(params[:id]).single_events
  end

  def for_tag
    render_events SingleEvent.only_tagged_with(params[:id]).in_region(current_region)
  end

  private

  def set_calendar_headers
    response.headers["Content-Type"] = "text/calendar; charset=UTF-8"
  end

  def render_events(events)
    ri_cal = RiCal.Calendar
    ri_cal.events.push(*events.to_a.map do |e|
      e.to_ri_cal_event(is_google_bot)
    end)
    render text: ri_cal
  end

  def render_empty
    render_events []
  end

  def gabba
    gabba = Gabba::Gabba.new "UA-40669307-2", "hacken.in"
    gabba.event "Event", GABBA_MAPPING[params[:action].to_sym]
  end

  def user
    User.find_by_guid(params[:guid]) || raise(ActiveRecord::RecordNotFound)
  end

end
