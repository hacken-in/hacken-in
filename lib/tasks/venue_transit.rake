desc "Exports the event/single_event venue contents into venue db."


task :export_Events => :environment do 
    @events = Event.find(:all)
    @events.each do |event|
      if event.location.blank? || Venue.where(location: event.location) == []
     	  @venue = Venue.create(
       			location: event.location.blank? ? event.name : event.location, 
       			street: event.street, 
       			zipcode: event.zipcode, 
       			city: event.city, 
       			country: event.country,
       			latitude: event.latitude,
       			longitude: event.longitude)
          if @venue
            puts event.location.blank? ? event.name : event.location + " safed in venue"
            @event = Event.find(event.id)
              if @event.update_attributes(venue_id: @venue.id)
                puts event.location + " safeing venue_id in Event"
              else
                puts event.location + " error safeing venue_id in Event"
              end  
          end 
      else
        puts event.location + " Location already exists"
      end
    end
    puts "Beware: One Event is w/o Venue_id!"
end


task :export_SingleEvents => :environment do 
    @events = SingleEvent.find(:all)
    @events.each do |event|
      @location = event.location.blank? ? event.event.name : event.location
      if Venue.where(location: @location) == []
     	  @venue = Venue.create(
       			location: event.location, 
       			street: event.street, 
       			zipcode: event.zipcode, 
       			city: event.city, 
       			country: event.country,
       			latitude: event.latitude,
       			longitude: event.longitude)
     	  if @venue
     	    puts event.location + " safed in venue"
            @event = SingleEvent.find(event.id)
              if @event.update_attributes(venue_id: @venue.id)
                puts event.location + " safeing venue_id in SingleEvent"
              else
                puts event.location + " error safeing venue_id in SingleEvent"
              end  
          end
      else
        puts event.location + " Location already exists"
      end
    end
end