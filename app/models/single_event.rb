class SingleEvent < ActiveRecord::Base
  belongs_to :event
  scope :in_future, where("occurrence >= ?", Time.now).order(:occurrence)
  default_scope order(:occurrence)

  def SingleEvent.find_or_create(parameters)
    event = self.where(parameters).first

    if event.nil?
      return self.create parameters
    else
      return event
    end
  end

  def SingleEvent.getNextWeeks(number_of_weeks)
    self.where(:occurrence => (Time.now.to_date)..((Time.now + number_of_weeks.weeks).to_date))
  end

  def title
    if self.topic.blank?
      self.event.name
    else
      "#{self.topic} (#{self.event.name})"
    end
  end

end
