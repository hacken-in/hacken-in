class ApplicationController < ActionController::Base
  include CommentsPathHelper
  include OpengraphHelper

  protect_from_forgery

  helper_method :mobile?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: "Leider darfst du das nicht."
  end
  
  
  private
  
  def mobile?
    request.user_agent =~ /Mobile|webOS/
  end

end
