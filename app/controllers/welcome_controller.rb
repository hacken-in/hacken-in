class WelcomeController < ApplicationController

  def index
    @single_events = SingleEvent.getNextWeeks 4

    if user_signed_in? && !current_user.hate_list.empty?
      @single_events.delete_if do |single_event|
        ((single_event.event.tag_list & current_user.hate_list).length > 0 &&
        (!single_event.users.include? current_user))
       end
    end
  end

  def abonnieren
    begin
      @event = Event.find params[:event_id] if params[:event_id]
      @single_event = SingleEvent.find params[:single_event_id] if params[:single_event_id]
    rescue ActiveRecord::RecordNotFound
      flash[:error] = "Event nicht gefunden"
    end
  end

end
