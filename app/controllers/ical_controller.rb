class IcalController < ApplicationController
  before_filter :set_calendar_headers

  rescue_from ActiveRecord::RecordNotFound, with: :render_empty

  def general
    render_events SingleEvent.in_region(current_region).recent_to_soon(3.months)
  end

  def personalized
    render_events user_by_guid.single_events.recent_to_soon(3.months)
  end

  def like_welcome_page
    user = user_by_guid
    @single_events = SingleEvent.recent_to_soon(3.months).in_region(current_region)
    @single_events.to_a.select! { |single_event| single_event.is_for_user? user } if user
    render_events @single_events
  end

  def for_single_event
    render_events SingleEvent.where(id: params[:id])
  end

  def for_event
    render_events Event.find(params[:id]).single_events
  end

  def for_tag
    render_events SingleEvent.only_tagged_with(params[:id]).in_region(current_region)
  end

  def everything
    # no kitchen sink though
    render_events SingleEvent.recent_to_soon(3.months)
  end

  private

  def set_calendar_headers
    response.headers["Content-Type"] = "text/calendar; charset=UTF-8"
  end

  def render_events(events)
    calendar = Icalendar::Calendar.new
    events.each do |e|
      calendar.add_event(e.to_ical_event)
    end
    render text: calendar.to_ical
  end

  def render_empty
    render_events []
  end

  def user_by_guid
    User.find_by_guid(params[:guid]) || raise(ActiveRecord::RecordNotFound)
  end

  def called_action
    [self.class.name, params[:action]].join("/")
  end

end
