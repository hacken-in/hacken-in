require 'location'

class Event < ActiveRecord::Base
  include Location
  geocoded_by :address
  after_validation :reset_geocode

  has_many :single_events
  has_many :comments, as: :commentable, dependent: :destroy

  before_save :schedule_to_yaml
  after_save :generate_single_events

  # Provide tagging
  acts_as_taggable

  def generate_single_events
    self.future_single_events_cleanup
    self.future_single_event_creation
  end

  # Delete SingleEvents that don't match the pattern
  def future_single_events_cleanup
    self.single_events.in_future.where(based_on_rule: true).each do |single_event|
      single_event.destroy unless schedule.occurs_at?(single_event.occurrence)
    end
  end

  # Add SingleEvents that are in the pattern, but haven't been created so far
  def future_single_event_creation
    self.schedule.next_occurrences(12).each do |occurence|
      SingleEvent.find_or_create(event_id: self.id, occurrence: occurence, based_on_rule: true)
    end
  end

  def schedule
    if @schedule.nil?
      if !self.schedule_yaml.blank?
        begin
          @schedule = IceCube::Schedule.from_yaml(self.schedule_yaml)
        rescue => e
          # Shit, parsing went wrong
        end
      end

      if @schedule.nil?
        @schedule = IceCube::Schedule.new(Time.now, :duration => 60 * 60)
      end
    end
    @schedule
  end

  def schedule=(cube_obj)
    @schedule = cube_obj
  end

  def title
    self.name
  end

  def to_param
    "#{self.id}-#{self.name.parameterize}"
  end

  def to_opengraph
    graph = {}
    graph["og:title"] = "#{self.name}"
    graph["og:description"] = ActionController::Base.helpers.truncate(ActionController::Base.helpers.strip_tags(self.description), length: 80) unless self.description.blank?
    graph["og:latitude"] = self.latitude if self.latitude
    graph["og:longitude"] = self.longitude if self.longitude
    graph["og:street-address"] = self.street unless self.street.blank?
    graph["og:locality"] = self.location unless self.location.blank?
    graph["og:postal-code"] = self.zipcode unless self.zipcode.blank?
    graph["og:country-name"] = self.country unless self.country.blank?
    graph
  end

  def update_start_time_and_duration(start_time, duration)
    self.schedule.start_time = start_time
    self.schedule.start_time = self.schedule.start_time.beginning_of_day if self.full_day
    self.schedule.duration = duration.to_i * 60
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
