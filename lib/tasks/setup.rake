namespace :setup do

  desc "add an administrator, rake setup:admin user=USERNAME password=PASSWORD email=EMAIL"
  task :admin => :environment do
    unless user = ENV["user"]
      puts "You must provide an username"
      exit
    end

    unless password = ENV["password"]
      puts "You must provide a password"
      exit
    end

    unless email = ENV["email"]
      puts "You must provide an email address"
      exit
    end

    if User.create!(:nickname => user, :password => password, :email => email, :admin => true)
      puts "User created"
    end
  end
end
