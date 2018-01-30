namespace :schedules do
  desc "Update all schedules to the current version of IceCube"
  task update: :environment do
    Event.all.each do |event|
      event.schedule_yaml = IceCube::Schedule.from_yaml(event.schedule_yaml).to_yaml
      event.save!
      print "."
    end
    puts
  end
end
