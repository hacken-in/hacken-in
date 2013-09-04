class Suggestion < ActiveRecord::Base
  attr_accessible :email_address, :description

  serialize :more, Hash

  validates_presence_of :description

  after_initialize :set_default_email_address

  def set_default_email_address
    self.email_address = User.current.email if self.new_record? and User.current.present? and User.current.email.present?
  end

end
