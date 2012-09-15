ActiveAdmin.register Event do
  menu priority: 14
  index do
    column :name
    column :location do |event|
      [
        event.location,
        event.street,
        event.zipcode,
        event.city
      ].delete_if { |info| info.empty? }.join ", "
    end
    column :url do |event|
      a "Link", href: event.url
    end
    column :twitter do |event|
      a "@#{event.twitter}", href: "http://twitter.com/#{event.twitter}" unless event.twitter.blank?
    end
    column :twitter_hashtag do |event|
      a "##{event.twitter_hashtag}", href: "http://twitter.com/search/%23#{event.twitter_hashtag}" unless event.twitter_hashtag.blank?
    end

    default_actions
  end
end
