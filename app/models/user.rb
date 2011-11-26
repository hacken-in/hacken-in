class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Tags hated by the user
  acts_as_taggable_on :hates

  has_many :comments

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_protected :admin

  validates :email, :uniqueness => true
  validates :nickname, :uniqueness => true
  validates_exclusion_of :nickname, :in => %w(admin, root, administrator, superuser), :message => "is reserved"

  validates :email, :presence => true
  validates :nickname, :presence => true

  # http://stackoverflow.com/questions/2997179/ror-devise-sign-in-with-username-or-email
  def self.find_for_database_authentication(conditions={})
    self.where("nickname = ?", conditions[:email]).limit(1).first ||
    self.where("email = ?", conditions[:email]).limit(1).first
  end

  def update_with_password(params={})
    if params[:password].blank? and params[:email] == self.email
      params.delete(:current_password)
      params.delete(:password)
      #params.delete(:password_confirmation) if params[:password_confirmation].blank?
      params.delete(:password_confirmation)
      self.update_without_password(params)
    else
      current_password = params.delete(:current_password)

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

end
