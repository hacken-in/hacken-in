ActiveAdmin.register RadarSetting do

  menu false
  controller do
    nested_belongs_to :event

    def destroy
      destroy!{ admin_event_path(params[:event_id]) }
    end

    def create
      create!{ admin_event_path(params[:event_id]) }
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
      f.input :radar_type, as: :select, collection: ["Meetup"]
      f.input :url
    end
  end

end
