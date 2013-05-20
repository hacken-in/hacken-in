class PagesController < ApplicationController
  def show
    if ["impressum"].include? params[:page_name]
      @page_name = params[:page_name].gsub(/\W/,'')
    else
      render 'missing', status: 404
    end
  end
end
