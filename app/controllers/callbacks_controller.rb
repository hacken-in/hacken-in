class CallbacksController < Devise::OmniauthCallbacksController
  
  # One method to serve them all!
  def all
    user = User.from_omniauth(request.env["omniauth.auth"])
    if user.persisted?
      flash.notice = "Signed in via #{request.env["omniauth.auth"]["provider"].capitalize}"
      sign_in_and_redirect user
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    end
  end
  
  alias_method :linkedin, :all
  alias_method :twitter, :all
  alias_method :facebook, :all
  alias_method :google_oauth2, :all
  alias_method :github, :all
end
