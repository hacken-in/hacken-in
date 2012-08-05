class Authorization < ActiveRecord::Base
  #Authorization belongs to a user
  belongs_to :user
  attr_accessible :provider, :uid, :user_id, :token, :secret, :token_expires, :temp_token
  
  validates_uniqueness_of [:provider, :uid]
  
  def self.create_authorization(auth, user = nil)
    a = Authorization.new(provider: auth.provider, uid: auth.uid, token: auth.credentials.token, secret: auth.credentials.secret, token_expires: Time.at(auth.credentials.expires_at))
    
    a.temp_token = SecureRandom.hex(40) if user.nil?
    a.user_id = user.id unless user.nil?
    
    a.save
    
    return a
  end
  
end
