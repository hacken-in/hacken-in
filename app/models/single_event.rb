class SingleEvent < ActiveRecord::Base
  belongs_to :event
  scope :in_future, where("time >= ?", Time.now)

  def description
    self.read_attribute(:description) || self.event.description
  end

  def SingleEvent.find_or_create(parameters)
    event = self.where(parameters).first

    if event.nil?
      return self.create parameters
    else
      return event
    end
  end
end
