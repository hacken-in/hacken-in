class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable, :omniauthable, 
         :recoverable, :rememberable, :trackable, :validatable

  # Tags hated by the user
  acts_as_taggable_on :hates
  acts_as_taggable_on :likes

  has_many :comments
  has_and_belongs_to_many :single_events, uniq: true
  
  #OmniAuth Authorizations
  has_many :authorizations
  
  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :allow_ignore_view
  attr_protected :admin

  validates :nickname, uniqueness: true
  validates :nickname, presence: true
  validates_exclusion_of :nickname, in: %w(admin, root, administrator, superuser), message: "is reserved"

  # http://stackoverflow.com/questions/2997179/ror-devise-sign-in-with-username-or-email
  def self.find_for_database_authentication(conditions={})
    self.where("nickname = ?", conditions[:email]).limit(1).first ||
    self.where("email = ?", conditions[:email]).limit(1).first
  end

  def update_with_password(params={})

    if params[:password].blank? and params[:email] == self.email
      params.delete(:current_password)
      params.delete(:password)
      params.delete(:password_confirmation)
      self.update_without_password(params)
    else
      current_password = params.delete(:current_password)

      params.delete(:password) if params[:password].blank?
      params.delete(:password_confirmation) if params[:password_confirmation].blank?

      result = if valid_password?(current_password)
        update_attributes(params)
      else
        self.attributes = params
        self.valid?
        self.errors.add(:current_password, current_password.blank? ? :blank : :invalid)
        false
      end

      clean_up_passwords
      result
    end

  end

  def allow_ignore_view?
    !!self.allow_ignore_view
  end

  def guid
    guid = read_attribute :guid

    if guid.blank?
      begin
        guid = (0..16).to_a.map {|a| rand(16).to_s(16)}.join
      end while User.where('guid = ?', guid).count > 0
      write_attribute :guid, guid
      self.save
    end

    return guid
  end

  # Detects if a user likes a single event
  #
  # This is the case if the user has more tags from the event-taglist in his
  # like-list than in his hate-list.
  #
  # @param [SingleEvent] single_event the event you want to check
  # @return [Boolean]
  def likes?(single_event)
    event_tags = single_event.tag_list + single_event.event.tag_list

    (event_tags & self.like_list).size > (event_tags & self.hate_list).size
  end

  def self.current
    Thread.current[:user]
  end

  def self.current=(user)
    Thread.current[:user] = user
  end

  def modify_tag_list(kind, action)
    list = self.send :"#{kind}_list"
    list.send action.keys.first, action.values.first
  end
  
  # Functions for Devise & Omniauth
  
  # Create a user from an OmniAuth request
  def self.from_omniauth(auth)
    raise auth
  end
  
  # Create a user with the devise session
  def self.new_with_session(paramas, session)
    if session["devise.user_attributes"]
      self.new(sesion["devise.user_attributes"]) do |user|
        user.attributes = params
        user.valid?
      end
    else
      super
    end
  end
  
  # Password is only required if no authorizations are present
  def password_required?
    super && authorizations.length > 0
  end
  
  # Update only requires a password if we have one
  def update_with_password(params, *options)
    if encrypted_password.blank?
      update_attributes(params, *options)
    else
      super
    end
  end
  
end
