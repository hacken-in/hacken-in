class SearchController < ApplicationController
  respond_to :html, :xml

  def index
    unless params[:search].blank?
      @single_events = SingleEvent.search(params[:search]).paginate(:page => params[:page])
    end
  end
end
