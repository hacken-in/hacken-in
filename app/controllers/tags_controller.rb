class TagsController < ApplicationController

  def index
    @tags = ActsAsTaggableOn::Tag.all

    query = params[:q]
    @tags.select! { |t| t.name.downcase.include? query } unless query.blank?

    respond_to do |format|
      format.js { render json: @tags.collect{|t| {name: t.name} } }
    end
  end

  def show
    @single_events = SingleEvent.in_future.where("occurrence < ? ", Date.today + 2.month).only_tagged_with(params[:tagname])
    @events = Event.tagged_with(params[:tagname])
    @events = @events.where("events.id not in (?)", @single_events.map{|s| s.event.id}) unless @single_events.empty?
  end

end
