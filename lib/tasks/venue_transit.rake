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
            if @venue && event.location.blank?
            @event = Event.find(event.id)
              if @event.update_attributes(venue_id: @venue.id)
                puts event.name + " safeing venue_id in Event"
              else
                puts event.name + " error safeing venue_id in Event"
              end  
          end 
      else
        puts event.location + " Location already exists"
      end
      if event.venue_id.blank? && !event.location.blank?
        @event = Event.find(event.id)
        @venue = Venue.find_by_location(event.location)
        if @event.update_attributes(venue_id: @venue.id)
          puts event.location + " safeing venue_id in Event"
        else
          puts event.location + " error safeing venue_id in Event"
        end  
      end 
    end
    puts "Beware: One Event is w/o Venue_id!"
end


task :export_SingleEvents => :environment do 
    @events = SingleEvent.find(:all)
    @events.each do |event|
      @location = event.location.blank? ? event.name : event.location
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
          @event = SingleEvent.find(event.id)
            if @event.update_attributes(venue_id: @venue.id)
              puts "safeing venue_id in SingleEvent"
            else
              puts "error safeing venue_id in SingleEvent"
            end  
          end
      else
        puts event.location + " Location already exists"
      end
      #safing venue_id in rest of single_events w/o name: 
      if event.venue_id.blank?
        @event = SingleEvent.find(event.id)
        @location = event.location.blank? ? event.event.name : event.location
        if Venue.where(location: @location) == []
          @venue = Venue.create(
            location: @location, 
            street: event.street, 
            zipcode: event.zipcode, 
            city: event.city, 
            country: event.country,
            latitude: event.latitude,
            longitude: event.longitude)
        end
        @venue = Venue.find_by_location(@location)
          if @event.update_attributes(venue_id: @venue.id)
            puts "safeing venue_id in SingleEvent"
          else
            puts "error safeing venue_id in SingleEvent"
          end
      end  
    end
end