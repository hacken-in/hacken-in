class SearchController < ApplicationController
  def index
    @search_result = if params[:search].present?
                       single_events = SingleEvent.search_in_region(params[:search], current_region)
                       SingleEventsByDay.new(single_events)
                     else
                       SingleEventsByDay.new([])
                     end
  end
end
