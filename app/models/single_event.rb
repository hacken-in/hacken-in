class SingleEvent < ActiveRecord::Base
  belongs_to :event
  scope :in_future, where("occurrence >= ?", Time.now).order(:occurrence)
  default_scope order(:occurrence)

  def self.find_or_create(parameters)
    event = where(parameters).first
    event.nil? ? create(parameters) : event
  end

  def self.getNextWeeks(number_of_weeks)
    where(:occurrence => (Time.now.to_date)..((Time.now + number_of_weeks.weeks).to_date))
  end

  def title
    self.topic.blank? ? self.event.name : "#{self.topic} (#{self.event.name})"
  end

end
