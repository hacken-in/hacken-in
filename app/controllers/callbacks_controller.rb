class CallbacksController < Devise::OmniauthCallbacksController
  
  # One method to serve them all!
  def all
    user = User.from_omniauth(request.env["omniauth.auth"])
    #temp_token = create_authorization(request.env["omniauth.auth"], user)
    
    if user.persisted?
      flash.notice = "Signed in via #{request.env["omniauth.auth"]["provider"].capitalize}"
      sign_in_and_redirect user
    else
      # Merge in the temp token manually, since it's not in the attributes
      session["devise.user_attributes"] = user.attributes.merge({ auth_temp_token: user.auth_temp_token })
      redirect_to new_user_registration_url
    end
  end
  
  alias_method :linkedin, :all
  alias_method :twitter, :all
  alias_method :facebook, :all
  alias_method :google_oauth2, :all
  alias_method :github, :all
end
