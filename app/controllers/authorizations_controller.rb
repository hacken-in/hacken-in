class AuthorizationsController < ApplicationController
  def destroy
    @auth = current_user.authorizations.find_by_id(params[:id])
    if (current_user.needs_one_authorization?)
      redirect_to edit_user_registration_path, notice: t('registrations.oauth.only_one_no_password')
    else
      @auth.destroy
      redirect_to edit_user_registration_path, notice: t('registrations.oauth.deleted', provider: @auth.provider.humanize)
    end
  end
end
