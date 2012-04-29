namespace :events do
  desc "update all events with ical feeds"
  task get_from_ical: :environment do
    Event.all.each do |event|
      event.process_ical
    end
  end
end
