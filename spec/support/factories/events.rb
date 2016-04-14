# encoding: utf-8
FactoryGirl.define do
  factory :simple, class: 'event' do
    association :venue, factory: :cowoco_venue
    association :picture, factory: :picture
    association :category, factory: :a_category
    region { RegionSlug.find_by_slug("koeln").try(:region) || FactoryGirl.create(:koeln_region) }
    name "SimpleEvent"
  end

  factory :full_event, class: 'event' do
    name "SimpleEvent"
    association :venue, factory: :cowoco_venue
    association :picture, factory: :picture
    association :category, factory: :a_category
    description "Dragée bonbon tootsie roll icing jelly sesame snaps croissant apple pie. Sugar plum pastry tiramisu candy liquorice. Sweet roll chocolate bar macaroon fruitcake dragée faworki macaroon gingerbread. Caramels fruitcake bonbon croissant jelly beans topping caramels fruitcake danish. Jelly-o caramels cheesecake sesame snaps bonbon wafer bear claw jelly beans. Cotton candy chocolate caramels jelly beans tart tart jujubes jelly-o muffin. Tart soufflé chocolate jujubes. Tootsie roll sweet apple pie tootsie roll fruitcake marshmallow pastry. Cupcake candy canes candy canes chocolate cake pudding sweet roll. Wafer biscuit bonbon carrot cake gummi bears pie liquorice marzipan pudding. Oat cake brownie tiramisu biscuit chocolate bar wafer applicake dragée. Sweet sugar plum tart soufflé tootsie roll faworki gummi bears. Jelly dessert croissant halvah biscuit caramels. Wafer oat cake gummies jelly-o cheesecake powder."
    region { RegionSlug.find_by_slug("koeln").try(:region) || FactoryGirl.create(:koeln_region) }
  end

  factory :event_with_tags, class: 'event' do
    name "Tagged Event"
    association :picture, factory: :picture
    association :category, factory: :a_category
    region { RegionSlug.find_by_slug("koeln").try(:region) || FactoryGirl.create(:koeln_region) }
    tag_list "ruby, rails"
  end

  factory :berlin_event, class: 'event' do
    name "Berlin Event"
    association :venue, factory: :berlin_venue
    association :category, factory: :a_category
    region { RegionSlug.find_by_slug("berlin").try(:region) || FactoryGirl.create(:berlin_region) }
  end

  factory :global_event, class: 'event' do
    name "Global Event"
    association :category, factory: :a_category
    region { RegionSlug.find_by_slug("global").try(:region) || FactoryGirl.create(:global_region) }
  end
end

