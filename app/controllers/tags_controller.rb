class TagsController < ApplicationController
  
  def index
    @tags = params[:q].blank? ? ActsAsTaggableOn::Tag.all : ActsAsTaggableOn::Tag.all.clone.delete_if{|t| !t.name.downcase.include?(params[:q])}

    respond_to do |format|
      format.js { render :json =>@tags.collect{|t| {:name => t.name} } }
    end
  end
  
  def show
    @events = Event.tagged_with(params[:id])
  end
  
end
