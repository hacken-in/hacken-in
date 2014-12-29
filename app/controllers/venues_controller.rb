class VenuesController < ApplicationController
  def show
    @venue = Venue.find_by_id(params[:venue])
  end
end
