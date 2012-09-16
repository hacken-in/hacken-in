class CalendarPresetCategory < ActiveRecord::Base
  attr_accessible :calendar_preset, :category

  belongs_to :calendar_preset
  belongs_to :category
end
