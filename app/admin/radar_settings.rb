ActiveAdmin.register RadarSetting do

  menu false
  controller do
    nested_belongs_to :event

    def destroy
      destroy!{ admin_event_path(params[:event_id]) }
    end

    def create
      create! do |success, failure|
        success.html do
          redirect_to admin_event_path(params[:event_id])
        end
      end
    end

    def permitted_params
      params.permit(radar_setting: [
        :event_id,
        :url,
        :radar_type
      ])
    end
  end

  form do |f|
    f.inputs "Radar Einstellung" do
      f.input :radar_type, as: :select, collection: ["Meetup", "Onruby", "Ical", "Rss", "Twitter"]
      f.input :url, hint: "Bei Meetup die URL der Gruppe, bei OnRuby die URL zur Startseite der Stadt, bei Twitter die URL zur Seite des Handles, bei iCal/RSS der Link zum jeweiligen Feed"
    end
    f.actions
  end

end
