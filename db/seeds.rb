# encoding: UTF-8

def insert_seed(model_class, seed)
  model_class.find_or_create_by!(id: seed.fetch(:id)) do |m|
    m.assign_attributes(seed)
  end
end

def seed(model_class, seeds)
  seeds.each do |seed|
    insert_seed(model_class, seed)
  end

  # Reset the Primary Key Sequence as the IDs are chosen manually
  ActiveRecord::Base.connection.reset_pk_sequence!(model_class.table_name)
end

seed(Region, [
  {id: 1, name: "Global",  slug: "global",   latitude: nil,     longitude: nil,     perimeter: nil,  active: true},
  {id: 2, name: "Köln",    slug: "koeln",    latitude: 50.946,  longitude: 6.95889, perimeter: 20.0, active: true},
  {id: 3, name: "Berlin",  slug: "berlin",   latitude: 52.5186, longitude: 13.4081, perimeter: 20.0, active: true},
  {id: 4, name: "München", slug: "muenchen", latitude: 48.1368, longitude: 11.5781, perimeter: 20.0, active: true},
  {id: 5, name: "Hamburg", slug: "hamburg",  latitude: 53.5653, longitude: 10.0014, perimeter: 20.0, active: false}
])

seed(Category, [
  {id: 1, title: "Bellen",        color: "#A9CB38"},
  {id: 2, title: "Miauen",        color: "#bd4ef3"},
  {id: 3, title: "Essen fassen",  color: "#273583"},
  {id: 4, title: "Gassi gehen",   color: "#b93e26"},
  {id: 5, title: "Kraulen",       color: "#ff9039"}
])

seed(Tag, [
  {id: 1, name: "bark",    category_id: nil},
  {id: 2, name: "meow",    category_id: nil},
  {id: 3, name: "fluff",   category_id: nil},
  {id: 4, name: "agile",   category_id: nil},
  {id: 5, name: "food",    category_id: nil},
  {id: 6, name: "strolls", category_id: nil}
])

seed(User, [
  {id: 1, email: "admin@hacken.local", password: "hacken_admin", password_confirmation: "hacken_admin", reset_password_token: nil, remember_created_at: nil, sign_in_count: 1, current_sign_in_at: nil, last_sign_in_at: nil, current_sign_in_ip: nil, last_sign_in_ip: nil, admin: true,  nickname: "adminadmin", current_region_id: 2, description: nil, github: nil, twitter: nil, homepage: nil, guid: nil, allow_ignore_view: nil, reset_password_sent_at: nil, image_url: nil, team: nil, name: nil, gravatar_email: nil},
  {id: 2, email: "user@hacken.local",  password: "hacken_user", password_confirmation: "hacken_user", reset_password_token: nil, remember_created_at: nil, sign_in_count: 0, current_sign_in_at: nil, last_sign_in_at: nil, current_sign_in_ip: nil, last_sign_in_ip: nil, admin: false, nickname: "useruser",   current_region_id: 2, description: nil, github: nil, twitter: nil, homepage: nil, guid: nil, allow_ignore_view: nil, reset_password_sent_at: nil, image_url: nil, team: nil, name: nil, gravatar_email: nil}
])

seed(Picture, [
  {id: 1, title: "Dog barking at a cloud",  description: "",                          box_image: File.open(Rails.root.join("spec/fixtures/uploads/dog_barks_at_cloud.jpg"))},
  {id: 2, title: "Loads of cats",           description: "",                          box_image: File.open(Rails.root.join("spec/fixtures/uploads/loads_of_cats.jpg"))},
  {id: 3, title: "Happy squirrel",          description: "Thats one happy squirrel!", box_image: File.open(Rails.root.join("spec/fixtures/uploads/happy_squirrel.jpg"))},
])

seed(Event, [
  {id: 1, name: "Gassi Gehen Köln",        region_id: 2, description: "Gemeinsames Gassi-Gehen aller Frauchen & Herrchen.",                schedule_yaml: "---\n:start_date: 2011-08-07 13:13:00.000000000 +02:00\n:duration: 10800\n:rrules: []\n:exrules: []\n:rtimes:\n- 2011-08-08 19:00:00.000000000 +02:00\n- 2011-11-15 19:00:00.000000000 +01:00\n- 2012-02-06 19:00:00.000000000 +01:00\n:extimes: []\n", url: "http://example.com/dogs", twitter: "dogs", full_day: false, twitter_hashtag: "", category_id: 1, venue_id: nil, venue_info: "", picture_id: 1},
  {id: 2, name: "Berliner Nüsschennerds",  region_id: 3, description: "Wer jetzt schon sammelt, ist im Winter satt!",                      schedule_yaml: "---\n:start_date: 2011-08-07 19:00:00.000000000 Z\n:duration: 7200\n:rrules:\n- :validations:\n    :day_of_week:\n      2:\n      - 2\n  :rule_type: IceCube::MonthlyRule\n  :interval: 1\n:exrules: []\n:rtimes:\n- 2011-08-09 19:00:00.000000000 +02:00\n- 2011-09-13 20:00:00.000000000 +02:00\n:extimes:\n- 2013-02-12 19:00:00.000000000 +01:00\n- :time: 2013-07-09 17:00:00.000000000 Z\n  :zone: Berlin\n- :time: 2013-09-10 17:00:00.000000000 Z\n  :zone: Berlin\n- :time: 2013-11-12 18:00:00.000000000 Z\n  :zone: Berlin\n- :time: 2014-01-14 18:00:00.000000000 Z\n  :zone: Berlin\n- :time: 2014-03-11 18:00:00.000000000 Z\n  :zone: Berlin\n- :time: 2014-05-13 17:00:00.000000000 Z\n  :zone: Berlin\n- :time: 2014-02-11 18:00:00.000000000 Z\n  :zone: Berlin\n", url: "http://example.com/nuts/", twitter: "common_squirrel", full_day: false, twitter_hashtag: "", category_id: 3, venue_id: 192, venue_info: "", picture_id: 3},
  {id: 3, name: "Cologne dot Cats",        region_id: 2, description: "Katzen. Katzen überall.",                                           schedule_yaml: "---\n:start_date: 2011-08-07 19:00:00.000000000 +02:00\n:duration: 10800\n:rrules:\n- :validations:\n    :day_of_week:\n      3:\n      - 2\n  :rule_type: IceCube::MonthlyRule\n  :interval: 1\n:exrules: []\n:rtimes:\n- 2011-08-10 18:30:00.000000000 +02:00\n:extimes: []\n", url: "http://example.com/cats", twitter: "cats", full_day: false, twitter_hashtag: "", category_id: 3, venue_id: 4, venue_info: "", picture_id: 2},
  {id: 4, name: "Agile Antilopes Munich",  region_id: 4, description: "A place to meet for artiodactyls interested in all things agile.",  schedule_yaml: "---\n:start_date: 2011-08-07 21:00:00.000000000 +02:00\n:end_time: 2011-08-07 21:00:00.000000000 Z\n:rrules: []\n:exrules: []\n:rtimes:\n- 2012-02-27 19:00:00.000000000 +01:00\n:extimes:\n- 2013-08-06 19:00:00.000000000 +02:00\n- 2013-10-01 19:00:00.000000000 +02:00\n- 2014-03-04 19:00:00.000000000 +01:00\n", url: "http://example.com/antilopez/", twitter: "AntilopePrints", full_day: false, twitter_hashtag: "", category_id: 3, venue_id: 5, venue_info: "", picture_id: nil},
  {id: 5, name: "Berlin Badgers",          region_id: 3, description: "Berlin badger don't care.",                                         schedule_yaml: "---\n:start_date: 2011-08-07 19:30:00.000000000 Z\n:duration: 7200\n:rrules:\n- :validations:\n    :day_of_week:\n      4:\n      - 3\n  :rule_type: IceCube::MonthlyRule\n  :interval: 1\n:exrules: []\n:rtimes:\n- 2012-01-12 19:00:00.000000000 +01:00\n- 2012-02-23 19:00:00.000000000 +01:00\n:extimes:\n- 2012-01-19 19:00:00.000000000 +01:00\n- 2012-02-16 19:00:00.000000000 +01:00\n- 2012-05-17 19:00:00.000000000 +02:00\n- :time: 2013-09-19 17:30:00.000000000 Z\n  :zone: Berlin\n", url: "http://example.com/badgers/", twitter: "UWBadgers", full_day: false, twitter_hashtag: "badger", category_id: 3, venue_id: 3, venue_info: "Here be venue-information", picture_id: nil},
])


seed(SingleEvent, [
  {id: 101, name: "Trees and such",                               description: "Barking up the right trees by Hasso Heinzmann\r\n\r\nProgressive scratching technologies by Bello Bauer", event_id: 1, occurrence: Time.now.to_s, url: nil, duration: nil, full_day: nil, twitter_hashtag: nil, based_on_rule: true, category_id: nil, venue_id: nil, venue_info: nil, picture_id: nil, twitter: nil, use_venue_info_of_event: true, region_id: nil},
  {id: 102, name: "Herding Cats",                                 description: "* Mauzi Mayer: Food as Code\r\n* Mucky Bude: Using the Whiskas REPL for debugging your bowl", event_id: 3, occurrence: Time.now.to_s, url: "", duration: nil, full_day: false, twitter_hashtag: "", based_on_rule: true, category_id: nil, venue_id: 69, venue_info: nil, picture_id: nil, twitter: nil, use_venue_info_of_event: true, region_id: nil},
  {id: 103, name: "Pitfalls and oppurtunities of peanut butter",  description: "", event_id: 2, occurrence: Time.now.to_s, url: "", duration: nil, full_day: false, twitter_hashtag: "#nuts", based_on_rule: true, category_id: nil, venue_id: nil, venue_info: nil, picture_id: nil, twitter: nil, use_venue_info_of_event: true, region_id: nil},
  {id: 104, name: "The lean flock",                               description: "Keeping your herd agile.", event_id: 4, occurrence: Time.now.to_s, url: "", duration: nil, full_day: false, twitter_hashtag: "", based_on_rule: true, category_id: nil, venue_id: nil, venue_info: nil, picture_id: nil, twitter: nil, use_venue_info_of_event: true, region_id: nil}
])

seed(RadarSetting, [
  {id: 1, event_id: 1, url: "http://gassigehen.example.com/gassi.rss", radar_type: "Rss", last_processed: "2014-03-07 05:46:42", last_result: "OK"}
])

seed(RadarEntry, [
  {id: 1, radar_setting_id: 1, entry_date: DateTime.now + 1.week, state: "UNCONFIRMED", content: {url: "http://gassigehen.example.com/meetup", title: "Meetup", description: "Awesome Event!", duration: 60}, entry_type: "NEW"}
])

seed(Venue, [
  {id: 1, location: "Kölner Dom",           region_id: 2, street: "Domkloster 4",       zipcode: "50667", city: "Köln",    country: "DE", latitude: 50.941278,  longitude: 6.958281,  url: "http://example.com/"},
  {id: 2, location: "Berliner Fernsehturm", region_id: 3, street: "Panoramastraße 1A",  zipcode: "10178", city: "Berlin",  country: "DE", latitude: 50.9385,    longitude: 6.94344,   url: ""},
  {id: 3, location: "Hofbräuhaus",          region_id: 4, street: "Platzl 9",           zipcode: "80331", city: "München", country: "DE", latitude: 48.137749,  longitude: 11.579882, url: nil},
  {id: 4, location: "Elbphilharmonie",      region_id: 5, street: "Am Kaiserkai",       zipcode: "20457", city: "Hamburg", country: "DE", latitude: 53.542348,  longitude: 9.9808,    url: ""},
])

seed(Comment, [
  {id: 1, body: "Oh my. This looks [like a hyperlink](http://example.com/some-url).", user_id: 2, commentable_id: 101, commentable_type: "SingleEvent"}
])

seed(Authorization, [
  {id: 1, provider: "github", uid: "1337", user_id: 1, token: nil, secret: nil, token_expires: nil, temp_token: nil},
])

seed(EventCuration, [
  {id: 1, user_id: 2, event_id: 3}
])

seed(RegionOrganizer, [
  {id: 1, region_id: 2, user_id: 2}
])

seed(Tagging, [
  {id: 1, tag_id: 1, taggable_id: 3, taggable_type: "Event", tagger_id: nil, tagger_type: nil, context: "tags"},
  {id: 2, tag_id: 2, taggable_id: 3, taggable_type: "Event", tagger_id: nil, tagger_type: nil, context: "tags"},
  {id: 3, tag_id: 3, taggable_id: 2, taggable_type: "Event", tagger_id: nil, tagger_type: nil, context: "tags"},
  {id: 4, tag_id: 5, taggable_id: 2, taggable_type: "Event", tagger_id: nil, tagger_type: nil, context: "tags"},
])
