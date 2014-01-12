namespace :twitter do

  desc "follows all events on twitter and puts them in lists for each city"
  task follow: :environment do
    puts "Please wait, checking da twitterz"
    TwitterAutomator.new.follow
    puts "Checking done!"
  end

end
