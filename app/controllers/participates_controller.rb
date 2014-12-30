#encoding: utf-8
class ParticipatesController < ApplicationController
  respond_to :html, :xml
  before_action :authenticate_user!

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
    if action == "push"
      @single_event.users.push(current_user) unless @single_event.users.include? current_user
    elsif action == "delete"
      @single_event.users.delete(current_user)
    end
  end
end
