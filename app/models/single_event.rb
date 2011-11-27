require 'location'

class SingleEvent < ActiveRecord::Base
  include Location
  after_validation :reset_geocode
  geocoded_by :address

  belongs_to :event
  has_many :comments, as: :commentable, dependent: :destroy
  has_and_belongs_to_many :users, :uniq => true

  scope :in_future, where("occurrence >= ?", Time.now).order(:occurrence)
  scope :today_or_in_future, where("occurrence >= ?", Time.now.beginning_of_day).order(:occurrence)
  default_scope order(:occurrence)

  # Provide tagging
  acts_as_taggable

  def self.find_or_create(parameters)
    event = where(parameters).first
    event.nil? ? create(parameters) : event
  end

  def self.getNextWeeks(number_of_weeks)
    where(:occurrence => (Time.now.to_date)..((Time.now + number_of_weeks.weeks).to_date)).sort
  end

  def title
    self.topic.blank? ? self.event.name : "#{self.event.name} (#{self.topic})"
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

  def to_opengraph
    graph = event.to_opengraph
    graph["og:title"] = self.name
    if !self.description.blank? || !self.topic.blank?
      graph["og:description"] = [
        self.topic,
        ActionController::Base.helpers.truncate(ActionController::Base.helpers.strip_tags(self.description), length: 80)
      ].delete_if{|x| x.blank?}.join(" - ")
    end
    graph
  end

  # Attribute aus dem Event-Model holen, wenn im SingleEvent nicht
  # definiert
  [:url, :duration, :full_day, :location, :street,
   :zipcode, :city, :country, :latitude, :longitude].each do |item|

    define_method item.to_s do
      if !self.read_attribute(item).blank?
        self.read_attribute(item)
      elsif !self.event.nil?
        self.event.read_attribute(item)
      end
    end
  end

end
