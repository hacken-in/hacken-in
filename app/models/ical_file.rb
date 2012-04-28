class IcalFile
  def initialize(ical_data)
    @events = RiCal.parse_string(ical_data).first.events
  end
  
  def number_of_events
    @events.length
  end
  
  def each_event(&block)
    @events.each do |event|
      block.call event
    end
  end
  
  def each_event_with_pattern(pattern, &block)
    @events.each do |event|
      block.call event if event.summary =~ pattern
    end
  end
end


