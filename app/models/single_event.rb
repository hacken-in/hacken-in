class SingleEvent < ActiveRecord::Base
  belongs_to :event
  scope :in_future, where("time >= ?", Time.now.to_s(:db))
end
