class SubscribeController < ApplicationController

  def index
    begin
      @event = Event.find params[:event_id] if params[:event_id]
      @single_event = SingleEvent.find params[:single_event_id] if params[:single_event_id]
      @tag = params[:tag_id]
    rescue ActiveRecord::RecordNotFound
      flash[:error] = t "subscriptions.index.error"
    end
  end

end

