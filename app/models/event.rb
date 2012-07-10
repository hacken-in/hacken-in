require 'location'
require 'time_extensions'

class Event < ActiveRecord::Base
  include Location
  geocoded_by :address

  after_validation :reset_geocode
  before_save :schedule_to_yaml
  after_save :generate_single_events

  has_many :single_events
  has_many :comments, as: :commentable, dependent: :destroy

  delegate :start_time, :start_time=, to: :schedule

  attr_writer :schedule

  acts_as_taggable

  def generate_single_events
    self.future_single_events_cleanup
    self.future_single_event_creation
  end

  # Delete SingleEvents that don't match the pattern
  def future_single_events_cleanup
    self.single_events.rule_based_in_future.each do |single_event|
      single_event.delete unless schedule.occurs_at? single_event.occurrence
    end
  end

  # Add SingleEvents that are in the pattern, but haven't been created so far
  def future_single_event_creation
    self.schedule.next_occurrences(12).each do |occurrence|
      # ToDo: Hot-Fix for Bug #83, unti ice_cube's issue 84 is resolved
      occurrence = occurrence.without_ms

      if !self.schedule.extimes.map(&:to_i).include? occurrence.to_i
        SingleEvent.where(event_id: self.id,
          occurrence: occurrence,
          based_on_rule: true).first_or_create
      end
    end
  end

  def schedule
    @schedule ||= begin
      IceCube::Schedule.from_yaml self.schedule_yaml
    rescue TypeError, Psych::SyntaxError
      IceCube::Schedule.new Time.now, duration: 1.hour
    end
  end

  def title
    self.name
  end

  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end

  def short_description
    return nil if self.description.blank?
    ActionController::Base.helpers.strip_tags(self.description).truncate 80
  end

  def to_opengraph
    {
      "og:title"          => name,
      "og:description"    => short_description,
      "og:latitude"       => latitude,
      "og:longitude"      => longitude,
      "og:street-address" => street,
      "og:locality"       => location,
      "og:postal-code"    => zipcode,
      "og:country-name"   => country
    }.reject { |key, value| value.blank? }
  end

  def duration
    schedule.duration / 60
  end

  def duration=(duration)
    schedule.duration = duration.to_i * 60
  end

  private

  def schedule_to_yaml
    self.schedule_yaml = @schedule.to_yaml if !@schedule.nil?
  end
end
