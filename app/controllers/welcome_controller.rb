class WelcomeController < ApplicationController

  def index
    flash.keep
    if session[:region]
      redirect_to region_url(region: session[:region])
    else
      redirect_to "/deutschland"
    end
  end

  def move_to
    region = RegionSlug.find_by_slug(params[:region]).try(:region)

    if region
      session[:region] = region.main_slug
      redirect_to region_url(region: region.main_slug)
    else
      redirect_to "/deutschland"
    end
  end

  def deutschland
  end

end
