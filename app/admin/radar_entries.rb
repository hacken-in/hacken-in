ActiveAdmin.register RadarEntry do
  filter :event, collection: -> { Event.joins(:radar_settings) }
  filter :state, as: :select, collection: ["UNCONFIRMED", "CONFIRMED"]

  before_filter :only => [:index] do
    if params['commit'].blank?
      params['q'] = {:state_eq => 'UNCONFIRMED'}
    end
  end

end
