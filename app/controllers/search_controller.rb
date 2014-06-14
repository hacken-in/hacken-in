class SearchController < ApplicationController
  def index
    unless params[:search].blank?
      single_events = SingleEvent.search_in_region(params[:search], current_region)
      @search_result = SearchResult.new(single_events, page)
    end
  end

  private

  def page
    params[:page] || 1
  end
end
