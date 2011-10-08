namespace :single_events do

  desc "generate single events for all events"
  task :generate => :environment do
    Event.all.each do |event|
      event.generate_single_events
    end
  end
end
