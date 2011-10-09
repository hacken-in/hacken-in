class TagsController < ApplicationController
  
  def index
    
  end
  
  def show
    @events = Event.tagged_with(params[:id])
  end
  
end