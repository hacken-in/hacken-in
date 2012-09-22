class HumansController < ApplicationController
  respond_to :html, :text

  def index
    @humans = User.where "team is not null"
    respond_with @humans
  end
end
