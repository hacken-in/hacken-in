namespace :venue do

  desc "Exports the event/single_event venue contents into venue db."
  task :move_events => :environment do
    Event.all.each do |event|
      copy_location event
    end
    SingleEvent.all.each do |sevent|
      copy_location sevent
    end
  end

  private

  def copy_location event
    if !event.location.blank? && event.venue_id.nil?
      venue = Venue.find_by_location(event.location)
      if venue.nil?
        venue = Venue.create(
          location: event.location.blank? ? event.name : event.location,
          street: event.street,
          zipcode: event.zipcode,
          city: event.city,
          country: event.country,
          latitude: event.latitude,
          longitude: event.longitude,
          country: "DE"
        )
      end
      event.venue = venue
      event.save
    end
  end
end
