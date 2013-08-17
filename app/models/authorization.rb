class Authorization < ActiveRecord::Base
  #Authorization belongs to a user
  belongs_to :user
  attr_accessible :provider, :uid, :user_id, :token, :secret, :token_expires, :temp_token

  validates_uniqueness_of :uid, :scope => :provider

  def self.create_authorization(auth, user = nil)
    auth_data = Authorization.extract_auth_data(auth)
    nick_data = Authorization.extract_nick_data(auth)

    a = Authorization.new(auth_data)
    if user.nil?
      a.temp_token = SecureRandom.hex(40)
    else
      a.user_id = user.id
      user.set_external_nickname(nick_data)
    end

    a.save

    return a
  end

  def self.extract_auth_data(auth)
    auth_data = {
      provider: auth.provider,
      uid: auth.uid,
      token: auth.credentials.token,
      secret: auth.credentials.secret
    }
    auth_data[:token_expires] = Time.at(auth.credentials.expires_at) if auth.credentials.expires_at

    auth_data
  end

  def self.extract_nick_data(auth)
    {
      auth.provider.to_sym => auth.info.nickname
    }
  end
end
