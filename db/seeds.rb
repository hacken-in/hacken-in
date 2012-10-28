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


post = BlogPost.create(
  headline: "Lorem ipsum blogpost headline",
  headline_teaser: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque libero elit, elementum et vestibulum a, dignissim non erat.",
  teaser_text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque libero elit, elementum et vestibulum a, dignissim non erat. Cras tincidunt, erat nec molestie faucibus, libero neque sodales tortor, at gravida libero elit vel odio. Duis ullamcorper lorem eget velit tincidunt ut pellentesque sem fermentum.",
  text: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Quisque libero elit, elementum et vestibulum a, dignissim non erat. Cras tincidunt, erat nec molestie faucibus, libero neque sodales tortor, at gravida libero elit vel odio. Duis ullamcorper lorem eget velit tincidunt ut pellentesque sem fermentum. Praesent ut quam sit amet augue sagittis tristique. Suspendisse hendrerit, velit non imperdiet ultricies, est urna dictum eros, nec dictum magna eros sollicitudin metus. Ut luctus, nulla vitae ultrices consectetur, turpis nibh porttitor lacus, ullamcorper egestas ante purus ut justo. Ut suscipit vehicula nisl, in adipiscing leo semper vel. Etiam varius sagittis leo, vitae commodo odio pellentesque vel. In id nunc in dolor sodales semper. Etiam mattis eros nunc, quis lobortis dui. Vestibulum porttitor tincidunt lacus, a dictum arcu gravida et. Donec et augue dictum ligula lacinia tincidunt et sodales tortor. Etiam dapibus tempor dui, sed bibendum augue tempus eget. In hac habitasse platea dictumst.

    Morbi scelerisque eros non erat posuere rutrum. Morbi eleifend pretium augue vitae faucibus. Pellentesque habitant morbi tristique senectus et netus et malesuada fames ac turpis egestas. Praesent vitae quam nec tortor ullamcorper euismod sit amet sed orci. Vivamus quis ultricies massa. Nunc pulvinar magna id metus accumsan in posuere quam rhoncus. Aliquam ac magna nisl. Cras a lectus sed dui rutrum porta eget quis mi. Vestibulum dignissim pellentesque nulla, sagittis adipiscing elit consequat at. Praesent eget augue sit amet diam fringilla sollicitudin vitae eu ligula. Sed placerat luctus leo, nec volutpat purus porttitor nec. Phasellus nec ante eu nulla euismod adipiscing. Aliquam ut urna sed sem dignissim mattis. Praesent semper nisi sed nisi interdum eu eleifend odio ultrices. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus.

    Sed porttitor tellus a lorem vulputate pharetra. Aliquam et neque mi. Nulla auctor odio vitae lacus fringilla id auctor orci porttitor. Aliquam velit dolor, condimentum a feugiat eget, auctor eget lorem. Cras ac nisi arcu. In vestibulum pellentesque est, quis ultricies neque tempus at. Fusce augue dolor, molestie at laoreet sed, malesuada nec nisi. Proin pretium erat vel urna hendrerit congue ac at est. Duis ac urna arcu, non lacinia libero. Praesent semper, mi in laoreet molestie, sem eros lacinia tellus, pulvinar convallis neque elit nec nulla. Praesent sed ante justo. Etiam vel risus libero. Curabitur purus lectus, blandit in rhoncus non, malesuada eu lacus. Donec quam dui, facilisis id lacinia nec, molestie a ligula. Sed non nunc ante, sit amet placerat dolor. Phasellus et diam ante, ut viverra ipsum.

    Vestibulum ante ipsum primis in faucibus orci luctus et ultrices posuere cubilia Curae; Nullam vel nisi eget nulla consequat rhoncus. Praesent hendrerit iaculis magna, nec tincidunt orci pulvinar pretium. Donec facilisis sem vitae erat bibendum vel convallis libero venenatis. In ac velit sit amet felis vulputate tempus. Duis porta dui eget eros suscipit elementum. Aliquam erat volutpat. Cras eu est vitae ligula convallis vulputate at vel mi. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos.

    Phasellus porttitor tortor ut risus gravida nec iaculis magna molestie. Mauris ut odio elit, a dignissim magna. Donec sed laoreet augue. Etiam turpis risus, facilisis sit amet fermentum id, lobortis eu metus. Vestibulum non augue sed massa laoreet ultrices et vehicula augue. In in tortor urna. Maecenas nec quam sed sem consectetur aliquet. In vehicula, purus sit amet auctor accumsan, libero ligula porta mauris, quis semper turpis ipsum at quam. Ut volutpat mattis nisi, ac blandit nunc interdum ac. Fusce scelerisque pretium nibh, quis elementum velit consequat id. Morbi sit amet orci ligula. Etiam cursus adipiscing consectetur. Ut volutpat placerat lorem, at gravida mauris egestas eget. Nullam a mauris id turpis molestie sollicitudin eget sit amet lacus. Suspendisse potenti.",
  user: User.first,
  category: Category.first,
  publishable: true,
  publishable_from: Date.yesterday
)

# ---- pictures ----

ThisiscolognePicture.create(
  description: '<img src=\"http://24.media.tumblr.com/tumblr_mc6kfjkfL91qk5i72o1_500.jpg\"/><br/><br/><p>stephih shared on Instagram: Good morning ',
  image_url: 'http://24.media.tumblr.com/tumblr_mc6kfjkfL91qk5i72o1_500.jpg',
  link: 'http://thisiscologne.tumblr.com/post/33946164095',
  time: '2012-10-20 07:21:18'
)
ThisiscolognePicture.create(
  description: '<img src=\"http://25.media.tumblr.com/tumblr_mc6a1qcAO91qk5i72o1_500.jpg\"/><br/><br/><p>cerbifc shared on Instagram: Köln am Rhein! good morning #instagram <a href=\"http://instagr.am/p/Q_RNePI_6J/\">http://instagr.am/p/Q_RNePI_6J/</a></p>',
  image_url: 'http://25.media.tumblr.com/tumblr_mc6a1qcAO91qk5i72o1_500.jpg',
  link: 'http://thisiscologne.tumblr.com/post/33937045513',
  time: '2012-10-20 03:37:02'
)
ThisiscolognePicture.create(
  description: '<img src=\"http://24.media.tumblr.com/tumblr_mc5swnnQCg1qk5i72o1_500.jpg\"/><br/><br/><p>stefan04 shared on Instagram: #cologne #thisiscologne #fall <a href=\"http://instagr.am/p/Q-o-2dAF26/\">http://instagr.am/p/Q-o-2dAF26/</a></p>',
  image_url: 'http://24.media.tumblr.com/tumblr_mc5swnnQCg1qk5i72o1_500.jpg',
  link: 'http://thisiscologne.tumblr.com/post/33913930738',
  time: '2012-10-19 21:26:47'
)
ThisiscolognePicture.create(
  description: '<img src=\"http://24.media.tumblr.com/tumblr_mc5s3uQ1Hx1qk5i72o1_500.jpg\"/><br/><br/><p>mrsberryde shared on Instagram: Decksteiner Weiher <a href=\"http://instagr.am/p/Q-nf4REoY_/\">http://instagr.am/p/Q-nf4REoY_/</a></p>',
  image_url: 'http://24.media.tumblr.com/tumblr_mc5s3uQ1Hx1qk5i72o1_500.jpg',
  link: 'http://thisiscologne.tumblr.com/post/33912836664',
  time: '2012-10-19 21:09:30'
)
ThisiscolognePicture.create(
  description: '<img src=\"http://24.media.tumblr.com/tumblr_mc5s3otjr41qk5i72o1_500.jpg\"/><br/><br/><p>mrsberryde shared on Instagram: Herbstspaziergang <a href=\"http://instagr.am/p/Q-nMJVEoYy/\">http://instagr.am/p/Q-nMJVEoYy/</a></p>',
  image_url: 'http://24.media.tumblr.com/tumblr_mc5s3otjr41qk5i72o1_500.jpg',
  link: 'http://thisiscologne.tumblr.com/post/33912829629',
  time: '2012-10-19 21:09:23'
)


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
