namespace :setup do

  desc "add an administrator, rake setup:admin user=USERNAME password=PASSWORD email=EMAIL"
  task admin: :environment do
    nick = ENV["user"] || begin
      puts "Username:"
      STDIN.gets.strip
    end

    password = ENV["password"] || begin
      puts "Password:"
      STDIN.gets.strip
    end

     email = ENV["email"] || begin
      puts "Emailaddress:"
      STDIN.gets.strip
    end

    if user = User.create!(nickname: nick, password: password, email: email)
      user.admin = true
      user.save
      puts "User created"
    end
  end
end
