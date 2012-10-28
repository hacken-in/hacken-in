class Advertisement < ActiveRecord::Base
  attr_accessible :calendar_week, :description, :duration, :file, :link, :context, :picture_id
  belongs_to :picture

end
