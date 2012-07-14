class CallbacksController < Devise::OmniauthCallbacksController
  def twitter
    user = User.from_omniauth(request.env["omniauth.auth"])
    if user.persisted?
      flash.notice = "Eingeloggt via Twitter"
      sign_in_and_redirect user
    else
      session["devise.user_attributes"] = user.attributes
      redirect_to new_user_registration_url
    end
  end
  
  def linkedin
  end
  
  def facebook
  end
  
  def google_oauth2
  end
  
  def github
  end
  
end
