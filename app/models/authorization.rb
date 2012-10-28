class Authorization < ActiveRecord::Base
  #Authorization belongs to a user
  belongs_to :user
  attr_accessible :provider, :uid, :user_id, :token, :secret, :token_expires, :temp_token

  validates_uniqueness_of [:provider, :uid]

  def self.create_authorization(auth, user = nil)
    auth_data = {
      provider: auth.provider,
      uid: auth.uid,
      token: auth.credentials.token,
      secret: auth.credentials.secret
    }
    auth_data[:token_expires] = Time.at(auth.credentials.expires_at) if auth.credentials.expires_at
    
    a = Authorization.new(auth_data)
    a.temp_token = SecureRandom.hex(40) if user.nil?
    a.user_id = user.id unless user.nil?

    a.save

    return a
  end
end
