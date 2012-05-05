class TagsController < ApplicationController

  def index
    @tags = params[:q].blank? ? ActsAsTaggableOn::Tag.all : ActsAsTaggableOn::Tag.all.clone.delete_if{|t| !t.name.downcase.include?(params[:q])}

    respond_to do |format|
      format.js { render json: @tags.collect{|t| {name: t.name} } }
    end
  end

  def show
    @single_events = SingleEvent.in_future.where("occurrence < ? ", Date.today + 2.month).by_tag(params[:tagname])
    @events = Event.tagged_with(params[:tagname]).where("events.id not in (?)", @single_events.map{|s| s.event.id})
  end

end
