class ParticipatesController < ApplicationController
  respond_to :html, :xml

  def create
    change_participation params[:single_event_id],
      :push,
      t("single_events.participate.confirmation")
  end

  def destroy
    change_participation params[:single_event_id],
      :delete,
      t("single_events.unparticipate.confirmation")
  end

  private

  def change_participation(id, how, confirmation)
    @single_event = SingleEvent.find id

    if user_signed_in?
      @single_event.users.send how, current_user
      flash[:notice] = confirmation
    else
      flash[:error] = t "devise.failure.unauthenticated"
    end

    respond_with @single_event,
      location: event_single_event_path(@single_event.event, @single_event)
  end
end
