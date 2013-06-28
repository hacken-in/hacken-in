ActiveAdmin.register Event do
  config.sort_order = "name_asc"
  menu priority: 2

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
      if event.twitter_hashtag.present?
        a "##{event.twitter_hashtag}", href: "http://twitter.com/search/%23#{event.twitter_hashtag}" unless event.twitter_hashtag.blank?
      else
        nil
      end
    end

    default_actions
  end

  show do
    render partial: 'show'
  end
  form do
    render partial: 'form'
  end

  controller do
    def create
      [[:schedule_rules_json, :schedule_rules], [:excluded_times_json, :excluded_times]].each do |item|
        if params[:event][item[0]]
          params[:event][item[1]] = JSON.parse(params[:event][item[0]])
          params[:event].delete item[0]
        end
      end
      create! do |format|
        format.html { redirect_to admin_event_path(@event) }
      end
    end
    def update
      [[:schedule_rules_json, :schedule_rules], [:excluded_times_json, :excluded_times]].each do |item|
        if params[:event][item[0]]
          params[:event][item[1]] = JSON.parse(params[:event][item[0]])
          params[:event].delete item[0]
        end
      end
      update! do |format|
        format.html { redirect_to admin_event_path(@event) }
      end
    end
  end

end
