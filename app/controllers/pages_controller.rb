class PagesController < ApplicationController

  PAGES = %w(impressum danke)

  def show
    if PAGES.include? params[:page_name]
      @page_name = params[:page_name].gsub(/\W/,'')
    else
      render 'missing', status: 404
    end
  end
end
