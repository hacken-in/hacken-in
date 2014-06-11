class SearchController < ApplicationController
  def index
    unless params[:search].blank?
      single_events = SingleEvent.in_region(current_region).search(params[:search])
      @search_result = SearchResult.new(single_events, params[:page])
    end
  end
end
