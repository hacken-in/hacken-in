class CallbacksController < Devise::OmniauthCallbacksController
  # One method to serve them all!
  def all

    # If there is no token, but we are currently logged in
    if current_user
      @auth = Authorization.create_authorization(request.env["omniauth.auth"], current_user)
      if @auth.persisted?
        redirect_to edit_user_registration_path, notice: t('registrations.oauth.added', provider: @auth.provider.humanize)
      else
        redirect_to edit_user_registration_path, flash: { error: t('registrations.oauth.in_use', provider: @auth.provider.humanize, uid: @auth.uid) }
      end
    else
      user = User.from_omniauth(request.env["omniauth.auth"])

      if user.persisted?
        flash.notice = "Signed in via #{request.env["omniauth.auth"]["provider"].capitalize}"
        sign_in_and_redirect user
      else
        # Merge in the temp token manually, since it's not in the attributes
        session["devise.user_attributes"] = user.attributes.merge({ auth_temp_token: user.auth_temp_token })
        redirect_to new_user_registration_url
      end
    end
  end

  alias_method :linkedin, :all
  alias_method :twitter, :all
  alias_method :facebook, :all
  alias_method :google_oauth2, :all
  alias_method :github, :all
end
