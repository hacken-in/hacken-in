class SearchController < ApplicationController
  def index
    redirect_to(region_path(current_region)) && return if params[:search].blank?
    single_events = SingleEvent.search_in_region(params[:search], current_region)
    @search_result = SearchResult.new(single_events)
  end
end
