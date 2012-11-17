require 'time_extensions'

class Event < ActiveRecord::Base

  validates_presence_of :name

  before_save :schedule_to_yaml
  after_save :generate_single_events

  belongs_to :category
  belongs_to :venue
  belongs_to :picture

  has_many :single_events, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  attr_writer :schedule

  acts_as_taggable

  # Workaround that makes it possible
  # to edit start times in active admin
  composed_of :start_time,
              :class_name => 'DateTime',
              :mapping => %w(DateTime to_s),
              :constructor => Proc.new{ |item| item },
              :converter => Proc.new{ |item| item }

  def self.search(search)
    unscoped.find(:all, :conditions => ['name LIKE ? OR description LIKE ?', "%#{search}%", "%#{search}%"])
  end

  def generate_single_events
    self.future_single_events_cleanup
    self.future_single_event_creation
  end

  # Delete SingleEvents that don't match the pattern
  def future_single_events_cleanup
    self.single_events.rule_based_in_future.each do |single_event|
      single_event.delete unless schedule.occurs_at?(single_event.occurrence)
    end
  end

  # Add SingleEvents that are in the pattern, but haven't been created so far
  def future_single_event_creation
    self.schedule.next_occurrences(12).each do |occurrence|
      # TODO: Hot-Fix for Bug #83, unti ice_cube's issue 84 is resolved
      occurrence = occurrence.without_ms

      if !self.schedule.extimes.map(&:to_i).include? occurrence.to_i
        SingleEvent.where(event_id: self.id,
          occurrence: occurrence,
          based_on_rule: true).first_or_create
      end
    end
  end

  def start_time
    schedule.start_time
  end

  def start_time=(value)
    schedule.start_time = value.to_time
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
    ogdata = {
      "og:title"          => name,
      "og:description"    => short_description
    }
    ogdata = ogdata.merge venue.to_opengraph unless venue.nil?
    ogdata = ogdata.reject { |key, value| value.blank? }
    ogdata
  end

  def duration
    schedule.duration / 60
  end

  def duration=(duration)
    schedule.duration = duration.to_i * 60
  end

  # This returns a simplified view of the icecube system
  # An example result would be:
  # [{"type" => 'monthly', "interval" => -1, "days" => ["monday"]}]
  # interval = -1 means last monday of the month, 2 means second monday
  def schedule_rules
    schedule.recurrence_rules.map do |rule|
      hash = {}
      hash["type"] = 'monthly' if rule.class == IceCube::MonthlyRule
      hash["interval"] = rule.validations_for(:day_of_week).first.occ
      hash["days"] = rule.validations_for(:day_of_week).map{|d| Date::DAYNAMES[d.day].downcase}
      hash
    end
  end

  def schedule_rules=(rules)
    schedule.recurrence_rules.each do |rule|
      schedule.remove_recurrence_rule rule
    end
    rules = JSON.load(rules) if rules.kind_of? String
    rules.each do |rule|
      week_hash = {}
      rule["days"].each do |d|
        week_hash[d.to_sym] = [rule["interval"].to_i]
      end
      schedule.add_recurrence_rule IceCube::Rule.monthly.day_of_week(week_hash)
    end
  end

  def excluded_times
    schedule.extimes
  end

  def excluded_times=(times)
    schedule.extimes.each do |time|
      schedule.remove_extime(time)
    end
    times = JSON.load(times) if times.kind_of? String
    times.each do |time|
      time = Time.parse(time) if time.kind_of? String
      schedule.extime(time.localtime)
    end
  end

  private

  def schedule_to_yaml
    self.schedule_yaml = @schedule.to_yaml if !@schedule.nil?
  end
end
