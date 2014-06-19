class SessionsController < Devise::SessionsController
  # Behaves like the default, but always remembers the user
  def create
    params[:user].merge!(remember_me: 1)
    super
  end
end
