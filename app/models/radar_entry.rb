class RadarEntry < ActiveRecord::Base
  belongs_to :radar_setting
  has_one :event, through: :radar_setting

end
