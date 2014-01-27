namespace :twitter do

  desc "follows all events on twitter and puts them in lists for each city"
  task follow: :environment do
    puts "Please wait, checking da twitterz"
    TwitterFollower.new.follow
    puts "Checking done!"
  end

  desc "add all twitter accounts to lists for each region"
  task update_lists: :environment do
    puts "Please wait, checking twitter lists"
    TwitterListUpdater.new.update
    puts "Checking done!"
  end

end
