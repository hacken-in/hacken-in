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

end
