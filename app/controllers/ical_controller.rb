class IcalController < ApplicationController
  before_filter :set_calendar_headers

  rescue_from ActiveRecord::RecordNotFound, with: :render_empty

  def general
    render_single_events SingleEvent.in_region(current_region).recent_to_soon(3.months)
  end

  def personalized
    render_single_events user_by_guid.single_events.recent_to_soon(3.months)
  end

  def like_welcome_page
    user = user_by_guid
    @single_events = SingleEvent.recent_to_soon(3.months).in_region(current_region)
    @single_events.to_a.select! { |single_event| single_event.is_for_user? user } if user
    render_single_events @single_events
  end

  def for_single_event
    render_single_events SingleEvent.where(id: params[:id])
  end

  def for_event
    render_single_events Event.find(params[:id]).single_events
  end

  def for_tag
    render_single_events SingleEvent.only_tagged_with(params[:id]).in_region(current_region)
  end

  def everything
    # no kitchen sink though
    render_single_events SingleEvent.recent_to_soon(3.months)
  end

  private

  def set_calendar_headers
    response.headers["Content-Type"] = "text/calendar; charset=UTF-8"
  end

  def render_single_events(single_events)
    render text: SingleEventIcal.to_icalendar(single_events)
  end

  def render_empty
    render_single_events []
  end

  def user_by_guid
    User.find_by_guid(params[:guid]) || raise(ActiveRecord::RecordNotFound)
  end

  def called_action
    [self.class.name, params[:action]].join("/")
  end

end
