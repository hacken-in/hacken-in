module ApplicationHelper

  def list_events(start_date, end_date)
    events = []
    Event.find_in_range(start_date, end_date).each do |event|
      event.schedule.occurrences_between(start_date, end_date).each do |time|
        events << [time, event]
      end
    end
    
    events.sort_by {|el| el.first}
  end

end
