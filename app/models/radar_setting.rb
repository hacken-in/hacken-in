class RadarSetting < ActiveRecord::Base
  has_many :entries, class_name: "RadarEntry"
  belongs_to :event

  def fetch
    get_parser.fetch
  end

  def get_parser
    "Radar::#{radar_type}".constantize.new(self)
  end

end
