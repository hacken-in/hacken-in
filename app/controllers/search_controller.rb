class SearchController < ApplicationController
  def index
    if params[:search].blank?
      redirect_to region_path(current_region) 
    else
      single_events = SingleEvent.search_in_region(params[:search], current_region)
      @search_result = SearchResult.new(single_events, page)
    end
  end

  private

  def page
    params[:page] || 1
  end
end
