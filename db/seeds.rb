# encoding: UTF-8

# STATUS:  this file contains some dummy seed data, but is far from complete.  Maybe it can serve as a base for creating some reals seeds in the future.


# clean DB
ActiveRecord::Base.establish_connection
ActiveRecord::Base.connection.tables.delete_if{|table| table == 'schema_migrations'}.each do |table|
  ActiveRecord::Base.connection.execute "TRUNCATE #{table}"  unless table == 'users'
end

## ---- categories -----

categories = [
  ['Social Media','#e6007e'],
  ['Gründerszene','#bd4ef3'],
  ['Programmieren','#0da693'],
  ['Software Engineering','#f7ca18'],
  ['Medienpädagogik','#ffed00'],
  ['Design','#14b4e3'],
  ['Netz-Aktivismus','#951b81'],
  ['Party','#273583'],
  ['Netzpolitik','#3da335'],
  ['Nerd-Kultur','#b93e26'],
  ['Gaming','#ff9039']
]
categories.each do |category|
  Category.create(title: category[0], color: category[1])
end

programming_category = Category.find_by_title("Programmieren")

# ---- venues -----

cowoco = Venue.create(
  location: 'Cowoco, Gasmotorenfabrik, 3. Stock',
  street: 'Deutz-Mülheimer Straße 129',
  zipcode: '51063',
  city: 'Köln',
  country: 'DE',
  latitude: 50.949,
  longitude: 6.98683
)
rechenzentrum = Venue.create(
  location: 'Benutzerrechenzentrum der Uni Köln',
  street: 'Berrenrather Str. 136',
  zipcode: '50937',
  city: 'Köln',
  country: 'DE',
  latitude: 50.9226,
  longitude: 6.92923
)

# ---- events -----

cgnjs = Event.create(
  name: 'Cologne.js',
  description: 'Kölner Javascript-Meetup.',
  schedule_yaml: '--- \n:start_date: 2011-08-07 19:00:00 +02:00\n:rrules: \n- :rule_type: IceCube::MonthlyRule\n  :interval: 1\n  :until: \n  :count: \n  :validations: \n    :day_of_week: \n      2: \n      - 2\n:exrules: []\n\n:rdates: \n- 2011-08-09 19:00:00 +02:00\n- 2011-09-13 20:00:00 +02:00\n:exdates: []\n\n:duration: 7200\n:end_time: \n',
  url: 'http://colognejs.de/',
  twitter: 'cgnjs',
  location: 'Cowoco, Gasmotorenfabrik, 3. Stock',
  street: 'Deutz-Mülheimer Straße 129',
  zipcode: '51063',
  city: 'Köln',
  latitude: 50.9491,
  longitude: 6.98682,
  full_day: false,
  category: programming_category,
  venue: cowoco
)
pycgn = Event.create(
  name: 'pyCologne',
  description: 'pyCologne ist eine Gruppe von Python-Interessenten aus der Region Köln-Bonn-Düsseldorf und zum Teil auch darüber hinaus. Sie setzt sich zusammen aus Studenten, Berufstätigen sowie ehemalig Berufstätige, Anfängern, Profis und solche, die es werden wollen. Die Teilnehmer kommen aus unterschiedlichen Tätigkeitsbereichen, sind bei privaten Firmen, öffentlichen Gesellschaften und Forschungseinrichtungen beschäftigt, sowie teils auch selbstständig.\r\n \r\nIn den monatlichen Treffen werden Neuigkeiten aus der Python-Welt vorgestellt und und diskutiert. Durch Vorträge der Mitglieder und externer Referenten werden die vielfältigen Möglichkeiten der Sprache aufgezeigt und es wird vorgestellt, wie Python eingesetzt wird und was mit Python bereits erreicht wurde.',
  schedule_yaml: '--- \n:start_date: 2011-08-07 18:30:00 +02:00\n:rrules: \n- :rule_type: IceCube::MonthlyRule\n  :interval: 1\n  :until: \n  :count: \n  :validations: \n    :day_of_week: \n      3: \n      - 2\n:exrules: []\n\n:rdates: \n- 2011-08-10 18:30:00 +02:00\n:exdates: []\n\n:duration: 10800\n:end_time: \n',
  url: 'http://wiki.python.de/pycologne/',
  twitter: 'pycologne',
  location: 'Benutzerrechenzentrum der Uni Köln',
  street: 'Berrenrather Str. 136',
  zipcode: '50937',
  city: 'Köln',
  latitude: 50.9226,
  longitude: 6.92923,
  full_day: true,
  category: programming_category,
  venue: rechenzentrum
)
