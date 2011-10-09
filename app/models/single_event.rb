class SingleEvent < ActiveRecord::Base
  belongs_to :event
  scope :in_future, where("time >= ?", Time.now)

  def description
    self.read_attribute(:description) || self.event.description
  end
end
