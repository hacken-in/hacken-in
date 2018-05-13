class PrivacySettingsController < ApplicationController
  # We can't verify the authenticity token, because the user has no cookies
  skip_before_filter :verify_authenticity_token, only: [:create]

  def show
  end

  def create
    cookies[:disable_privacy_mode] = true
    redirect_to privacy_settings_path
  end

  def destroy
    cookies.delete(:disable_privacy_mode)
    redirect_to privacy_settings_path
  end
end
