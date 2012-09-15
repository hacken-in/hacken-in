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
    column :twitter
    column :twitter_hashtag
    default_actions
  end
end
