ActiveAdmin.register Event do
  index do
    column :name
    column :description
    column :location do |event|
      [
        event.location,
        event.street,
        event.zipcode,
        event.city
      ].delete_if { |info| info.empty? }.join ", "
    end
    column :url
    column :twitter
    column :twitter_hashtag
    default_actions
  end
end
