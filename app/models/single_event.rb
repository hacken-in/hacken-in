class SingleEvent < ActiveRecord::Base
  belongs_to :event
  scope :in_future, where("'when' >= ?", Time.now)

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

  def SingleEvent.getNextWeeks(number_of_weeks)
    self.where(:when => (Time.now.to_date)..((Time.now + number_of_weeks.weeks).to_date)).order("'when' ASC")
  end

end
