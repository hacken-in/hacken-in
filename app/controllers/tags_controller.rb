class TagsController < ApplicationController
  
  def index
    @tags = params[:q].blank? ? ActsAsTaggableOn::Tag.all : ActsAsTaggableOn::Tag.all.clone.delete_if{|t| !t.name.downcase.include?(params[:q])}

    respond_to do |format|
      format.js { render :json =>@tags.collect{|t| {:name => t.name} } }
    end
  end
  
  def show
    @single_events = SingleEvent.in_future.where("occurrence < ? ", Date.today + 2.month).tagged_with(params[:tagname]).to_a
    @events = []
    Event.tagged_with(params[:tagname]).order(:name).each do |event|
      future_events = event.single_events.in_future.where("occurrence < ? ", Date.today + 2.month)
      unless future_events.empty?
        @single_events = @single_events + future_events
      else
        @events << event
      end
    end
    @single_events = @single_events.sort_by(&:occurrence)
  end

end
