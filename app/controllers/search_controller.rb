class SearchController < ApplicationController
  respond_to :html, :xml

  def index
  	    #authorize! :index, Search
  	unless params[:search].blank?
      @single_events = SingleEvent.search(params[:search]) 
      @events = Event.search(params[:search])
      @blog_posts = BlogPost.search(params[:search])
      respond_with @events, @blog_posts, @single_events
    end
  end
end
