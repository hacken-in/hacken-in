#encoding: utf-8
class ParticipatesController < ApplicationController
  respond_to :html, :xml

  def update
    @single_event = SingleEvent.find params[:single_event_id]

    push_or_delete(params[:state].to_s)
    flash[:notice] = t "single_events.#{params[:state]}.confirmation"

    respond_with @single_event do |format|
      format.html { redirect_to event_single_event_path(@single_event.event, @single_event) }
      format.js
    end
  end

  private

  def push_or_delete(action)
    if user_signed_in?
      handle_signed_in_user(action)
    else
      handle_external_user(action)
    end
  end

  def handle_signed_in_user(action)
    if action == "push"
      @single_event.users.push(current_user)
    elsif action == "delete"
      @single_event.users.delete(current_user)
    end
  end

  def handle_external_user(action)
    if action == "push"
      # Eine UUID im Cookie speichern, damit der Nutzer nachträglich noch
      # sagen kann, dass er doch nicht teilnehmen möchte
      external_user_session_token = (cookie.permanent[:hacken_uuid] ||= SecureRandom.uuid)
      single_event_user = @single_event.external_users.new(email: params[:email], name: params[:name], session_token: external_user_session_token)

      if single_event_user.save
        # Wenn keep_data gesetzt ist, email und name in einem permanenten Cookie ablegen
        # sodass es beim nächsten mal wieder verwendet werden kann
        if params[:keep_data]
          cookie.permanent[:hacken_daten] = {email: params[:email], name: params[:name]}
        end
      else
        # TODO: Fehler beim Speichern behandeln
      end
    elsif action == "delete"
      single_event_user = @single_event.external_users.find_by_session_token(cookie[:hacken_uuid])
      if single_event_user
        single_event_user.destroy
      end
    end
  end
end
