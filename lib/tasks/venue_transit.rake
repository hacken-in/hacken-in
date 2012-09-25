desc "Exports the event/single_event venue contents into venue db."


task :export_Events => :environment do 

    @events = Event.find(:all)
    @events.each do |event|
      if event.location.blank? || Venue.find_by_location(event.location).nil? 
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
            # to direkt safe blank locations:
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
  
      unless event.location.blank?
      	@event = Event.find(event.id)
        @venue = Venue.find_by_location(event.location)
        if @event.update_attributes(venue_id: @venue.id)
          puts event.location + " safeing venue_id in Event"
        else
          puts event.location + " error safeing venue_id in Event"
        end  
      end
    end
end

task :export_SingleEvents => :environment do 

    @events = SingleEvent.find(:all)
    @events.each do |event|
      if event.location.blank? || Venue.find_by_location(event.location).nil? 
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
     	    # to direkt safe blank locations:
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
 
      unless event.location.blank?
      	@event = SingleEvent.find(event.id)
        @venue = Venue.find_by_location(event.location)
        if @event.update_attributes(venue_id: @venue.id)
          puts event.location + " safeing venue_id in SingleEvent"
        else
          puts event.location + " error safeing venue_id in SingleEvent"
        end  
      end
    end
end