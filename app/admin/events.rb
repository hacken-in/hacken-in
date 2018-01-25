ActiveAdmin.register Event do
  config.sort_order = "name_asc"
  menu priority: 2

  filter :name
  filter :region
  filter :category

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

    actions
  end

  show do
    render partial: 'show'
  end

  form partial: 'form'

  controller do
    def permitted_params
      # TODO: this is a sad workaround, I could not
      # find a valid way to permit the schedule_rules and excluded_times
      # values from the event. Those are arrays and are filtered out
      # by default :(
      params.permit!
      # params.permit(event: %i[
      #   name
      #   region_id
      #   description
      #   schedule_yaml
      #   url
      #   twitter
      #   created_at
      #   updated_at
      #   full_day
      #   twitter_hashtag
      #   category_id
      #   venue_id
      #   venue_info
      #   picture_id
      #   tag_list
      #   start_time(1i)
      #   start_time(2i)
      #   start_time(3i)
      #   start_time(4i)
      #   start_time(5i)
      #   duration
      #   week_number
      #   day_of_week
      #   id
      # ])
    end

    def create
      params[:event][:schedule_rules] = JSON.parse(params[:event][:schedule_rules]) if params[:event][:schedule_rules]
      params[:event][:excluded_times] = JSON.parse(params[:event][:excluded_times]) if params[:event][:excluded_times]
      reconstruct_start_time
      create! do |success|
        success.html do
          redirect_to admin_event_path(@event)
        end
      end
    end

    def update
      params[:event][:schedule_rules] = JSON.parse(params[:event][:schedule_rules]) if params[:event][:schedule_rules]
      params[:event][:excluded_times] = JSON.parse(params[:event][:excluded_times]) if params[:event][:excluded_times]
      reconstruct_start_time
      update! do |success|
        success.html do
          redirect_to admin_event_path(@event)
        end
      end
    end

    private

    # Reconstruct the start time from its fragments
    def reconstruct_start_time
      params[:event]["start_time"] = Time.zone.local(
        params[:event].delete("start_time(1i)").to_i,
        params[:event].delete("start_time(2i)").to_i,
        params[:event].delete("start_time(3i)").to_i,
        params[:event].delete("start_time(4i)").to_i,
        params[:event].delete("start_time(5i)").to_i
      )
    end
  end
end
