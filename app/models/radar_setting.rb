class RadarSetting < ActiveRecord::Base
  has_many :entries, -> { order(:entry_date) }, class_name: 'RadarEntry', dependent: :destroy
  belongs_to :event

  def fetch
    get_parser.fetch
  end

  def get_parser
    "Radar::#{radar_type}".constantize.new(self)
  end

end
