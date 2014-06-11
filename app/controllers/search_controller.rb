class SearchController < ApplicationController
  def index
    unless params[:search].blank?
      @single_events = Kaminari.paginate_array(SingleEvent.in_region(current_region).search(params[:search])).page(params[:page]).per(10)
    end
  end
end
