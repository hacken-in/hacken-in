namespace :twitter do

  desc "follows all events on twitter and puts them in lists for each city"
  task follow: :environment do
    TwitterFollower.new.follow
  end

  desc "add all twitter accounts to lists for each region"
  task update_lists: :environment do
    TwitterListUpdater.new.update
  end

end
