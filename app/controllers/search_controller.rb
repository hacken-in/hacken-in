class SearchController < ApplicationController
  respond_to :html, :xml

  def index
    unless params[:search].blank?
      @single_events = Kaminari.paginate_array(SingleEvent.search(params[:search])).page(params[:page]).per(10)
    end
  end
end
