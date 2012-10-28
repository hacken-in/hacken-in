require "calendar_week"

class Advertisement < ActiveRecord::Base
  attr_accessible :calendar_week, :description, :duration, :file, :link, :context, :picture_id
  belongs_to :picture

  def Advertisement.homepage
    Advertisement.where(context: 'homepage').where(calendar_week: DateTime.now.iso_cweek).first
  end
end
