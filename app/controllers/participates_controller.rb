class ParticipatesController < ApplicationController
  respond_to :html, :xml

  def update
    @single_event = SingleEvent.find params[:single_event_id]

    if user_signed_in?
      @single_event.users.send params[:state].to_sym, current_user
      flash[:notice] = t("single_events.#{params[:state]}.confirmation")
    else
      flash[:error] = t "devise.failure.unauthenticated"
    end

    respond_with @single_event do |format|
      format.html { redirect_to event_single_event_path(@single_event.event, @single_event) }
      format.js
    end
  end
end
