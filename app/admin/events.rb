ActiveAdmin.register Event do
  menu parent: "Kalender"
  config.sort_order = "name_asc"
  index do
    column :id
    column :name
    column :category
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

  show do
    render partial: 'show'
  end
  form do
    render partial: 'form'
  end

end
