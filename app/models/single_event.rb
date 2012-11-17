class SingleEvent < ActiveRecord::Base

  after_destroy :update_event

  belongs_to :category
  belongs_to :venue
  belongs_to :event
  belongs_to :picture

  delegate :title, :description, to: :event, prefix: true
  delegate :twitter, to: :event

  has_many :comments, as: :commentable, dependent: :destroy
  has_and_belongs_to_many :users, uniq: true

  validates_presence_of :event_id

  scope :in_future,
    where("occurrence >= ?", Time.now)
  scope :today_or_in_future,
    where("occurrence >= ?", Time.now.beginning_of_day)
  scope :most_current_for_event,
    order("occurrence DESC")
  scope :recent,
    lambda { |limit = 3| today_or_in_future.limit(limit) }
  scope :rule_based_in_future,
    in_future.where(based_on_rule: true)
  scope :in_next,
    lambda { |delta| where(occurrence: (Time.now.to_date)..((Time.now + delta).to_date)) }
  scope :in_next_from,
    lambda { |delta, start_date| where(occurrence: (start_date)..((start_date + delta).to_date)) }
  scope :recent_to_soon,
    lambda { |delta| where(occurrence: (Time.now.to_date - delta)..((Time.now + delta).to_date)) }
  scope :only_tagged_with,
    lambda { |tag| tagged_with(tag) | joins(:event).where('events.id in (?)', Event.tagged_with(tag).map(&:id)) }
  scope :in_categories,
    lambda { |categories| categories.blank? ? scoped : scoped.joins(:event).where('single_events.category_id IN (?) OR (single_events.category_id IS NULL AND events.category_id IN (?))', categories, categories) }

  default_scope includes(:event).order([:occurrence, 'single_events.name ASC', 'events.name ASC'])

  acts_as_taggable

  def self.search(search)
    unscoped.find(:all, :conditions => ['name LIKE ? OR description LIKE ?', "%#{search}%", "%#{search}%"])
  end

  # This is a little workaround. Rails optimizes .exists? queries and
  # removes includes from the current used scope. Sadly we have the
  # event table in the default scope and need the include. The workaround
  # is to use an unscoped query to check if an entry exists. This
  # can have sideeffects. Be warned!
  def self.exists?(id)
    unscoped.exists?(id)
  end

  def full_name
    self.name.blank? ? self.event.name : "#{self.event.name} (#{self.name})"
  end

  alias :to_s :full_name
  alias :title :full_name

  def name_with_date
    if self.full_day
      "#{self.full_name} am #{self.occurrence.strftime("%d.%m.%Y")}"
    else
      "#{self.full_name} am #{self.occurrence.strftime("%d.%m.%Y um %H:%M")}"
    end
  end

  def <=>(other)
    if (self.occurrence.year != other.occurrence.year) || (self.occurrence.month != other.occurrence.month) || (self.occurrence.day != other.occurrence.day)
      # not on same day
      return self.occurrence <=> other.occurrence
    elsif self.full_day
      if other.full_day
        # both are all day, sort via topic
        return self.full_name <=> other.full_name
      else
        # self is all day, other is not
        return -1
      end
    elsif other.full_day
      # other is all day, self is not
      return 1
    else
      # both are not all day, sort via time
      time_comparison = (self.occurrence <=> other.occurrence)

      if time_comparison == 0
        # they are at the same time, sort via topic
        return self.full_name <=> other.full_name
      else
        return time_comparison
      end
    end
  end

  def short_description
    return event.short_description if self.description.blank?
    ActionController::Base.helpers.strip_tags(self.description).truncate 80
  end

  def to_opengraph
    ogdata = event.to_opengraph.merge({
      "og:title"       => name_with_date,
      "og:description" => short_description
    })
    ogdata = ogdata.merge venue.to_opengraph unless venue.nil?
    ogdata = ogdata.reject { |key, value| value.blank? }
    ogdata
  end

  alias :self_category :category
  def category
    self.self_category || (self.event && self.event.category)
  end

  alias :self_venue :venue
  def venue
    self.self_venue || self.event.venue
  end

  alias :self_picture :picture
  def picture
    self.self_picture || self.event.picture
  end

  # Get the attribute from the Event model unless they exist here
  [:url, :twitter_hashtag, :duration, :full_day, :category_id, :venue_info].each do |item|
    define_method item.to_s do
      value = self.read_attribute(item)
      if !value.nil? && !(value.class.to_s == "String" && value.blank?)
        value
      elsif !self.event.blank?
        self.event.send(item)
      end
    end
  end

  def to_ri_cal_event
    ri_cal_event = RiCal::Component::Event.new
    ri_cal_event.summary = full_name
    ri_cal_event.description = ActionController::Base.helpers.strip_tags("#{description}\n\n#{event.description}".strip)

    start_time = occurrence
    end_time  = (occurrence + (event.schedule.duration || 1.hour))

    if full_day
      ri_cal_event.dtstart = start_time.to_date
      ri_cal_event.dtend = end_time.to_date
    else
      ri_cal_event.dtstart = start_time.utc
      ri_cal_event.dtend = duration.nil? ? end_time.utc : (start_time + duration.minutes).utc
    end

    location = [self.venue_info, self.venue.address].delete_if(&:blank?).join(", ").strip
    ri_cal_event.location = location if location.present?
    ri_cal_event.url = Rails.application.routes.url_helpers.event_single_event_url(
              host: Rails.env.production? ? "nerdhub.de" : "hcking.dev",
              event_id: event.id,
              id: id)
    ri_cal_event
  end

  def update_event
    if based_on_rule
      event.schedule.add_exception_time occurrence
      if event.schedule.rtimes.include? occurrence
        event.schedule.remove_recurrence_time occurrence
      end
      event.save
    end
  end

  def is_for_user?(user)
    return true unless user
    # Let us be a little more verbose than the old code
    # !((self.event.tag_list & user.hate_list).length > 0 && self.users.exclude?(user))
    hated_tags_event = (self.event.tag_list & user.hate_list)
    hated_tags_self  = (self.tag_list & user.hate_list)

    loved_tags_event = (self.event.tag_list & user.like_list)
    loved_tags_self  = (self.tag_list & user.like_list)

    # Wenn der Event oder der Single Event einen Tag haben, den der Benutzer hasst...
    if hated_tags_event.size + hated_tags_self.size > 0
      # ... muss der Benutzer mindestens einen der anderen Tags des Events lieben
      if loved_tags_event.size + loved_tags_self.size > 0
        # ... damit er angezeigt wird
        true
      # ... oder er muss an dem Event teilnehmen
      elsif self.users.include? user
        true
      else
        false
      end
    else
      true
    end

  end
end

