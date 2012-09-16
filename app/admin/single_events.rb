ActiveAdmin.register SingleEvent do
  menu priority: 6
  config.sort_order = "occurrence_asc"
  index do
    column :id
    column :name do |single_event|
      single_event.name || single_event.event.name
    end
    column :description do |single_event|
      single_event.description.try :truncate, 80
    end
    column :occurrence
    column :location do |single_event|
      [
        single_event.location,
        single_event.street,
        single_event.zipcode,
        single_event.city
      ].delete_if { |info| info.empty? }.join ", "
    end
    column :url do |single_event|
      a "Link", href: single_event.url
    end
    column :twitter do |single_event|
      a "@#{single_event.twitter}", href: "http://twitter.com/#{single_event.twitter}" unless single_event.twitter.blank?
    end
    column :twitter_hashtag do |single_event|
      a "##{single_event.twitter_hashtag}", href: "http://twitter.com/search/%23#{single_event.twitter_hashtag}" unless single_event.twitter_hashtag.blank?
    end
    default_actions
  end
end
