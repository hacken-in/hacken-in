class PagesController < ApplicationController
  PAGES = %w(impressum)

  def show
    if PAGES.include? params[:id]
      @page_name = params[:id]
    else
      render 'missing', status: 404
    end
  end

  def robots
    respond_to :text
  end
end
