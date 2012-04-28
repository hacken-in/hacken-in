require 'location'

class SingleEvent < ActiveRecord::Base
  include Location
  after_validation :reset_geocode
  after_destroy :update_event
  geocoded_by :address

  belongs_to :event
  delegate :title, :name, :description, :city, :to => :event, :prefix => true

  has_many :comments, as: :commentable, dependent: :destroy
  has_and_belongs_to_many :users, :uniq => true

  scope :in_future, where("occurrence >= ?", Time.now).order(:occurrence)
  scope :today_or_in_future, where("occurrence >= ?", Time.now.beginning_of_day).order(:occurrence)
  scope :recent, lambda { |limit = 3| order(:occurrence).limit(limit) }

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
    if self.full_day
      "#{self.title} am #{self.occurrence.strftime("%d.%m.%Y")}"
    else
      "#{self.title} am #{self.occurrence.strftime("%d.%m.%Y um %H:%M")}"
    end
  end

  def <=>(other)
    if (self.occurrence.year != other.occurrence.year) || (self.occurrence.month != other.occurrence.month) || (self.occurrence.day != other.occurrence.day)
      # not on same day..,
      return self.occurrence <=> other.occurrence
    elsif self.full_day
      if other.full_day
        # both are all day
        # sort via topic
        return self.title <=> other.title
      else
        # self is all day, other is not
        return -1
      end
    elsif other.full_day
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
  [:url, :twitter_hashtag, :duration, :full_day, :location, :street,
   :zipcode, :city, :country, :latitude, :longitude].each do |item|

    define_method item.to_s do
      value = self.read_attribute(item)
      if !value.nil? && !(value.class.to_s == "String" && value.blank?)
        value
      elsif !self.event.blank?
        self.event.read_attribute(item)
      end
    end
  end

  def populate_event_for_rical(cal)
    start_time = self.occurrence
    end_time  = (self.occurrence + (self.event.schedule.duration || 3600))

    if self.full_day
      start_time = start_time.to_date
      end_time = end_time.to_date
    else
      start_time = start_time.utc
      end_time = end_time.utc
      if !duration.nil?
        end_time = start_time + duration.minutes
      end
    end

    loc = [self.location, self.address].delete_if{|d|d.blank?}.join(", ").strip
    url = Rails.application.routes.url_helpers.event_single_event_url(
              :host => Rails.env.production? ? "hcking.de" : "hcking.dev",
              :event_id => self.event.id,
              :id => self.id)

    description = ActionController::Base.helpers.strip_tags("#{self.description}\n\n#{self.event.description}".strip)

    summary = self.title

    cal.event do |event|
      event.summary     = summary
      event.description = description
      event.dtstart     = start_time
      event.dtend       = end_time
      event.location    = loc unless loc.blank?
      event.url         = url
    end

  end

  def update_event
    if based_on_rule
      event.schedule.add_exception_time(occurrence)
      event.save
    end
  end
end
