class Authorization < ActiveRecord::Base
  #Authorization belongs to a user
  belongs_to :user
  attr_accessible :provider, :uid, :user_id
end
