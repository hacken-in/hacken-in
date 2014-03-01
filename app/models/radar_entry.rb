class RadarEntry < ActiveRecord::Base
  belongs_to :radar_setting
  has_one :event, through: :radar_setting

  serialize :content
  serialize :previous_confirmed_content

  def confirm
    self.previous_confirmed_content = content
    self.content = nil
    self.state = "CONFIRMED"
    self.save
  end

end
