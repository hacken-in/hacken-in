class Event < ActiveRecord::Base
  before_save :schedule_to_yaml

  validates_presence_of :name

  def self.find_in_range(start_date, end_date)
    events = []
    Event.all.each do |event|
      events << event if event.schedule.occurrences_between(start_date, end_date).size > 0
    end
    events
  end

  def self.get_ordered_events(start_date, end_date)
    events = []
    Event.find_in_range(start_date, end_date).each do |event|
      event.schedule.occurrences_between(start_date, end_date).each do |time|
        events << {time: time, event:event}
      end
    end

    events.sort_by {|el| el.first}
  end

  def schedule
    if @schedule.nil?
      if !self.schedule_yaml.blank?
        @schedule = IceCube::Schedule.from_yaml(self.schedule_yaml)
      else
        @schedule = IceCube::Schedule.new(Time.now)
      end
    end
    @schedule
  end

  def schedule=(cube_obj)
    @schedule = cube_obj
    self.schedule_yaml = cube_obj.to_yaml
  end

  private

  def schedule_to_yaml
    self.schedule_yaml = self.schedule.to_yaml
  end

end
