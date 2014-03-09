class RadarEntry < ActiveRecord::Base
  belongs_to :radar_setting
  has_one :event, through: :radar_setting
  has_one :region, through: :event

  serialize :content
  serialize :previous_confirmed_content

  module States
    CONFIRMED = "CONFIRMED"
    UNCONFIRMED = "UNCONFIRMED"
  end

  def confirm
    self.previous_confirmed_content = content
    self.content = {}
    self.state = RadarEntry::States::CONFIRMED
    self.save
  end

end
