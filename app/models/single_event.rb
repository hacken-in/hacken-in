class SingleEvent < ActiveRecord::Base
  belongs_to :event
  has_many :comments, :as => :commentable

  scope :in_future, where("occurrence >= ?", Time.now).order(:occurrence)
  default_scope order(:occurrence)

  def self.find_or_create(parameters)
    event = where(parameters).first
    event.nil? ? create(parameters) : event
  end

  def self.getNextWeeks(number_of_weeks)
    where(:occurrence => (Time.now.to_date)..((Time.now + number_of_weeks.weeks).to_date)).sort
  end

  def title
    self.topic.blank? ? self.event.name : "#{self.topic} (#{self.event.name})"
  end

  def name
    if self.event.full_day
      "#{self.title} am #{self.occurrence.strftime("%d.%m.%Y")}"
    else
      "#{self.title} am #{self.occurrence.strftime("%d.%m.%Y um %H:%M")}"
    end
  end

  def <=>(other)
    if (self.occurrence.year != other.occurrence.year) || (self.occurrence.month != other.occurrence.month) || (self.occurrence.day != other.occurrence.day)
      # not on same day..,
      return self.occurrence <=> other.occurrence
    elsif self.event.full_day
      if other.event.full_day
        # both are all day
        # sort via topic
        return self.title <=> other.title
      else
        # self is all day, other is not
        return -1
      end
    elsif other.event.full_day
      # sother is all day, self is not
      return 1
    else
      # both are not all day
      # sort via time
      time_comparison = (self.occurrence <=> other.occurrence)

      if time_comparison == 0
        # they are at the same time
        # sort via topic
        return self.title <=> other.title
      else
        return time_comparison
      end
    end
  end

end
