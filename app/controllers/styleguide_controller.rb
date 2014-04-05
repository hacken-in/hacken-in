class StyleguideController < ApplicationController
  before_action :require_region!, only: [ :show ]

  def index
    @styleguide ||= Kss::Parser.new("#{Rails.root}/app/assets/stylesheets")

    case params[:reference].to_i
    when 1.0
      render :template => "styleguide/css/buttons"
    end
  end

end
