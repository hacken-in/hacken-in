ActiveAdmin.register SingleEvent do
  menu priority: 15
  index do
    column :name
    column :description do |single_event|
      single_event.description.try :truncate, 80
    end
    column :occurrence
    column :url do |single_event|
      link_to "URL", single_event.url unless single_event.url.blank?
    end
    column :location do |single_event|
      [
        single_event.location,
        single_event.street,
        single_event.zipcode,
        single_event.city
      ].delete_if { |info| info.empty? }.join ", "
    end
    column :twitter
    column :twitter_hashtag
    default_actions
  end
end
