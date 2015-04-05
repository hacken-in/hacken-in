class Event < ActiveRecord::Base
  include TwitterHashTagFixer

  validates_presence_of :name
  validates_presence_of :category

  validates :duration, :numericality => { :greater_than => 0 }

  before_save :schedule_to_yaml
  after_save :generate_single_events

  belongs_to :category
  belongs_to :venue
  belongs_to :picture

  belongs_to :region

  has_many :single_events, dependent: :destroy
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :event_curations
  has_many :curators, :through => :event_curations, :source => :user

  has_many :radar_settings

  attr_writer :schedule

  acts_as_taggable

  # Search for region, but also check for region_id = 1, that is the global region
  scope :in_region, ->(region) { where('region_id = ? or region_id = 1', region)}
  scope :name_or_description_like, ->(search) { where(arel_table[:name].matches(search).or(arel_table[:description].matches(search))) }

  def self.search(search)
    unscoped.name_or_description_like("%#{search}%")
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
      if !self.schedule.extimes.map(&:to_i).include? occurrence.to_i
        SingleEvent.where(event_id: self.id,
                          occurrence: occurrence.utc,
                          based_on_rule: true).first_or_create
      end
    end
  end

  def start_time
    schedule.start_time.in_time_zone
  end

  def start_time=(value)
    duration = schedule.duration
    schedule.start_time = value.to_time
    schedule.end_time = schedule.start_time + duration
  end

  def schedule
    @schedule ||= begin
      IceCube::Schedule.from_yaml self.schedule_yaml
    rescue TypeError, Psych::SyntaxError
      IceCube::Schedule.new Time.now, duration: 1.hour
    end
  end

  def to_s
    self.name
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
    ((schedule.end_time - schedule.start_time) / 60).to_i
  end

  def duration=(duration)
    schedule.end_time = schedule.start_time + duration.to_i * 60
  end

  # This returns a simplified view of the icecube system
  # An example result would be:
  # [{"type" => 'monthly', "interval" => -1, "days" => ["monday"]}]
  # interval = -1 means last monday of the month, 2 means second monday
  def schedule_rules
    schedule.recurrence_rules.map do |rule|
      hash = {}
      if rule.class == IceCube::MonthlyRule
        hash["type"] = 'monthly'
        hash["interval"] = rule.validations_for(:day_of_week).first.occ
        hash["days"] = rule.validations_for(:day_of_week).map{|d| Date::DAYNAMES[d.day].downcase}
      elsif rule.class == IceCube::WeeklyRule
        hash["type"] = 'weekly'
        hash["interval"] = rule.validations_for(:interval).first.interval
        hash["days"] = rule.validations_for(:day).map{|d| Date::DAYNAMES[d.day].downcase}
      end
      hash
    end
  end

  def schedule_rules=(rules)
    schedule.recurrence_rules.each do |rule|
      schedule.remove_recurrence_rule rule
    end
    rules = JSON.load(rules) if rules.kind_of? String
    rules.each do |rule|
      if (rule["type"] == 'monthly')
        add_monthly_schedule rule
      elsif (rule["type"] == 'weekly')
        add_weekly_schedule rule
      end
    end
  end

  def add_monthly_schedule(rule)
    week_hash = {}
    rule["days"].each do |d|
      week_hash[d.to_sym] = [rule["interval"].to_i]
    end
    schedule.add_recurrence_rule IceCube::Rule.monthly.day_of_week(week_hash)
  end

  def add_weekly_schedule(rule)
    days = rule["days"].map(&:to_sym)
    schedule.add_recurrence_rule IceCube::Rule.weekly(rule["interval"].to_i).day(*days)
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

  # Returns the best fitting single event for a
  # given date. The next coming up event is preferred.
  # When there is none, the most recent one is returned.
  # When there are no events, nil is returned
  def closest_single_event(date=Date.today)
    return nil if single_events.to_a.empty?

    coming_up = single_events.to_a.select { |s| s.occurrence.to_date >= date }.sort_by { |s| s.occurrence }

    if coming_up.empty?
      single_events.last
    else
      coming_up.first
    end
  end

  def self.group_by_category
    Hash[Event.group("category_id").count.map {|category_id, amount_of_events| [ Category.title_for(category_id), amount_of_events ] }]
  end

  private

  def schedule_to_yaml
    self.schedule_yaml = @schedule.to_yaml if !@schedule.nil?
  end
end
