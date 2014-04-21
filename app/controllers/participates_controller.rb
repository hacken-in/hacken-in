#encoding: utf-8
class ParticipatesController < ApplicationController
  respond_to :html, :xml

  def update
    @single_event = SingleEvent.find params[:single_event_id]

    if push_or_delete(params[:state].to_s)
      flash[:notice] = t "single_events.#{params[:state]}.confirmation"
      redirect_params = {}
    else
      redirect_params = { email: params[:email], name: params[:name] }
    end

    respond_with @single_event do |format|
      format.html { redirect_to event_single_event_path(@single_event.event, @single_event, redirect_params) }
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
      @single_event.users.push(current_user) unless @single_event.users.include? current_user
    elsif action == "delete"
      @single_event.users.delete(current_user)
    end
  end

  def handle_external_user(action)
    if action == "push"
      # Eine UUID im Cookie speichern, damit der Nutzer nachträglich noch
      # sagen kann, dass er doch nicht teilnehmen möchte
      external_user_session_token = if cookies[:hacken_uuid].present?
                                      cookies[:hacken_uuid]
                                    else
                                      cookies.permanent.signed[:hacken_uuid] = SecureRandom.uuid
                                    end

      single_event_user = @single_event.external_users.new(email: params[:email], name: params[:name], session_token: external_user_session_token)

      if single_event_user.save
        # Wenn keep_data gesetzt ist, email und name in einem permanenten Cookie ablegen
        # sodass es beim nächsten mal wieder verwendet werden kann
        if params[:keep_data]
          cookies.permanent.signed[:hacken_daten] = {email: params[:email], name: params[:name]}.to_json
        else
          cookies.delete(:hacken_daten)
        end
      else
        flash[:error] = single_event_user.errors.full_messages.to_sentence
        return false
      end
    elsif action == "delete"
      single_event_user = @single_event.external_users.find_by_session_token(cookies[:hacken_uuid])
      if cookies[:hacken_uuid].present? && single_event_user
        single_event_user.destroy
      else
        #TODO: Localize
        flash[:error] = "Du nimmst an diesem Event nicht teil"
        return false
      end
    end

    true
  end
end
