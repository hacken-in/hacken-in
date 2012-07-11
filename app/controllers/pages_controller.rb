class PagesController < ApplicationController
  rescue_from ActionView::MissingTemplate, with: :missing

  def show
    @page_name = params[:page_name].to_s.gsub(/\W/,'')
  end

  private

  def missing
    render 'missing', status: 404
  end
end
