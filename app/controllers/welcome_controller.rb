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
    region = Region.find_by_slug(params[:region])

    if region
      session[:region] = region.slug
      redirect_to region_url(region: region.slug)
    else
      redirect_to "/deutschland"
    end
  end

  def deutschland
  end

end
