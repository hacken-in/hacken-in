class ApplicationController < ActionController::Base
  include CommentsPathHelper
  include OpengraphHelper

  protect_from_forgery

  before_filter :set_current_user, :all_regions
  before_filter :configure_permitted_parameters, if: :devise_controller?

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: "Leider darfst du das nicht."
  end

  # TODO: Dies ist notwendig, da bei ActiveAdmin noch ein
  #       Bug existiert, der das Locale leider auf Englisch
  #       zurücksetzt. Siehe auch:
  #       https://github.com/gregbell/active_admin/issues/434
  before_filter :set_locale

  def set_locale
    I18n.locale = params[:locale] || I18n.default_locale
  end

  def authenticate_admin_user!
    # Rais error if not signed in or user not allowed to see the dashboard
    raise SecurityError and return if active_admin_user.nil?
    authenticate_user!
  end

  def after_sign_in_path_for(resource)
    "/deutschland"
  end

  def active_admin_user #use predefined method name
    return nil if !user_signed_in? || !can?(:read, ActiveAdmin::Page, :name => "Dashboard")
    current_user
  end
  helper_method :active_admin_user

  rescue_from SecurityError do |exception|
    redirect_to root_url, alert: "Leider darfst du das nicht :("
  end

  def is_google_bot
    !request.env["HTTP_USER_AGENT"].match(/googlebot/i).nil?
  end

  def all_regions
    @all_regions = Region.where(active: true)
  end

  def current_region
    @current_region ||= RegionSlug.find_by_slug(params[:region]).try(:region) || Region.find_by_id(params[:region])
  end
  helper_method :current_region

  # Raise a Not Found Routing Exception if no region was set
  def require_region!
    raise ActionController::RoutingError.new('Not Found') if current_region.nil?
  end

  def get_ical_link_for(action, protocol)
    if protocol == 'google'
      raw_url = url_for(action: action, protocol: 'http', controller: 'ical', format: 'ical', guid: current_user.guid)
      "http://google.com/calendar/render?cid=#{CGI.escape(raw_url)}"
    else
      url_for(action: action, protocol: protocol, controller: 'ical', format: 'ical', guid: current_user.guid)
    end
  end
  helper_method :get_ical_link_for

  def staging_users_should_be_warned
    session[:region].nil? && Rails.application.config.x.release_stage == :master
  end
  helper_method :staging_users_should_be_warned

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << :nickname
    devise_parameter_sanitizer.for(:sign_up) << :name

    devise_parameter_sanitizer.for(:account_update) << :nickname
    devise_parameter_sanitizer.for(:account_update) << :name
    devise_parameter_sanitizer.for(:account_update) << :description
    devise_parameter_sanitizer.for(:account_update) << :twitter
    devise_parameter_sanitizer.for(:account_update) << :github
    devise_parameter_sanitizer.for(:account_update) << :homepage
    devise_parameter_sanitizer.for(:account_update) << :gravatar_email
    devise_parameter_sanitizer.for(:account_update) << :allow_ignore_view
  end

  private

  def set_current_user
    User.current = current_user
  end

end
