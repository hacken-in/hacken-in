class CalendarPreset < ActiveRecord::Base
  attr_accessible :title, :user, :categories, :user_id, :category_ids

  belongs_to :user
  has_many :calendar_preset_categories
  has_many :categories, :through => :calendar_preset_categories

  scope :nerdhub_presets, where(CalendarPreset.arel_table[:user_id].eq(nil))
  scope :user_presets, where(CalendarPreset.arel_table[:user_id].not_eq(nil))
end
