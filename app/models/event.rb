require 'location'

class Event < ActiveRecord::Base
  include Location
  geocoded_by :address

  after_validation :reset_geocode
  before_save :schedule_to_yaml
  after_save :generate_single_events

  has_many :single_events
  has_many :comments, as: :commentable, dependent: :destroy

  attr_writer :schedule

  # Provide tagging
  acts_as_taggable

  def generate_single_events
    self.future_single_events_cleanup
    self.future_single_event_creation
  end

  # Delete SingleEvents that don't match the pattern
  def future_single_events_cleanup
    rule_based_events = self.single_events.in_future.where based_on_rule: true

    rule_based_events.each do |single_event|
      single_event.delete unless schedule.occurs_at? single_event.occurrence
    end
  end

  # Add SingleEvents that are in the pattern, but haven't been created so far
  def future_single_event_creation
    self.schedule.next_occurrences(12).each do |time|
      # remove milliseconds from occurrence, this causes a bug
      # in sqlite since it uses milliseconds. Sadly the milliseconds
      # the ice_cube generates are different each time. It's the
      # current millisecond when the method is called
      # (See https://github.com/seejohnrun/ice_cube/issues/84)
      occurrence = Time.new time.year,
        time.month,
        time.day,
        time.hour,
        time.min,
        time.sec

      # ToDo: Hot-Fix for Bug #83
      if !self.schedule.extimes.map(&:to_i).include? occurrence.to_i
        SingleEvent.find_or_create event_id: self.id,
          occurrence: occurrence,
          based_on_rule: true
      end
    end
  end

  def schedule
    if @schedule.nil?
      if self.schedule_yaml.present?
        begin
          @schedule = IceCube::Schedule.from_yaml self.schedule_yaml
        rescue => e
          # Shit, parsing went wrong
        end
      end

      if @schedule.nil?
        @schedule = IceCube::Schedule.new Time.now, duration: 1.hour
      end
    end
    @schedule
  end

  def title
    self.name
  end

  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end

  def short_description
    if self.description.blank?
      nil
    else
      description = ActionController::Base.helpers.strip_tags self.description
      description.truncate 80
    end
  end

  def to_opengraph
    graph = {}

    graph["og:title"]          = self.name         unless self.name.blank?
    graph["og:description"]    = short_description unless short_description.blank?
    graph["og:latitude"]       = self.latitude     unless self.latitude.blank?
    graph["og:longitude"]      = self.longitude    unless self.longitude.blank?
    graph["og:street-address"] = self.street       unless self.street.blank?
    graph["og:locality"]       = self.location     unless self.location.blank?
    graph["og:postal-code"]    = self.zipcode      unless self.zipcode.blank?
    graph["og:country-name"]   = self.country      unless self.country.blank?

    graph
  end

  def duration
    schedule.duration / 60
  end

  def duration=(duration)
    self.schedule.duration = duration.to_i * 60
  end

  def start_time
    schedule.start_time
  end

  def start_time=(start_time)
    schedule.start_time = start_time
  end

  private

  def schedule_to_yaml
    self.schedule_yaml = @schedule.to_yaml if !@schedule.nil?
  end
end
