namespace :db do
  desc "Fill database with sample data"
  task populate: :environment do
    make_events
    make_single_events
    make_blog_posts
  end
end


def make_events
  10.times do
    name = Faker::Lorem.sentence(5)
    description = Faker::Lorem.sentence(18)
    Event.create!(name: name, description: description)
  end
end

def make_single_events
  events = Event.all
  5.times do
    name = Faker::Lorem.sentence(5)
    description = Faker::Lorem.sentence(18)
    occurrence = Time.new(2012,12,1,12,00)
    events.each { |event| event.single_events.create!(name: name, description: description, occurrence: occurrence) }
  end
end

def make_blog_posts
  admin = User.create!(nickname:     "ExampleUser",
                       email:    "example4@adress.org",
                       password: "foobar",
                       admin: true
                       )
  category = Category.create!(title: "Fun")
  10.times do
    headline = Faker::Lorem.sentence(3)
    headline_teaser = Faker::Lorem.sentence(4)
    teaser_text = Faker::Lorem.sentence(5)
    text = Faker::Lorem.sentence(18)
    BlogPost.create!(headline: headline, 
                     headline_teaser: headline_teaser, 
                     teaser_text: teaser_text,
                     text: text,
                     user: admin,
                     category: category)
  end
end


