class ApplicationController < ActionController::Base
  include CommentsPathHelper

  protect_from_forgery

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => "Leider darfst du das nicht."
  end

end
