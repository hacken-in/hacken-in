# Have to add this manually because we use cancancan
require 'active_admin/cancan_adapter'

ActiveAdmin.setup do |config|
  config.site_title = "hacken.in"

  # == User Authentication
  #
  # Active Admin will automatically call an authentication
  # method in a before filter of all controller actions to
  # ensure that there is a currently logged in admin user.
  #
  # This setting changes the method which Active Admin calls
  # within the controller.
  config.authentication_method = :authenticate_admin_user!

  # == Current User
  #
  # Active Admin will associate actions with the current
  # user performing them.
  #
  # This setting changes the method which Active Admin calls
  # to return the currently logged in user.
  config.current_user_method = :active_admin_user

  # == Logging Out
  #
  # Active Admin displays a logout link on each screen. These
  # settings configure the location and method used for the link.
  #
  # This setting changes the path where the link points to. If it's
  # a string, the strings is used as the path. If it's a Symbol, we
  # will call the method to return the path.
  config.logout_link_path = :destroy_user_session_path

  # This setting changes the http method used when rendering the
  # link. For example :get, :delete, :put, etc..
  config.logout_link_method = :delete

  # == Admin Comments
  #
  # Admin comments allow you to add comments to any model for admin use.
  # Admin comments are enabled by default.
  config.comments = false

  # == Batch Actions
  #
  # Enable and disable Batch Actions
  config.batch_actions = true

  # == Authorization
  config.authorization_adapter = ActiveAdmin::CanCanAdapter
  config.cancan_ability_class = "ActiveAdminAbility"
end
