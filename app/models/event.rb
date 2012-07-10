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
      @schedule = begin
        IceCube::Schedule.from_yaml self.schedule_yaml
      rescue TypeError, Psych::SyntaxError
        IceCube::Schedule.new Time.now, duration: 1.hour
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
