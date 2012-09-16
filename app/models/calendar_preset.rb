class CalendarPreset < ActiveRecord::Base
  attr_accessible :title, :user, :categories, :user_id, :category_ids

  belongs_to :user
  has_many :calendar_preset_categories
  has_many :categories, :through => :calendar_preset_categories

  scope :nerdhub_presets, where(CalendarPreset.arel_table[:user_id].eq(nil))
  scope :user_presets, where(CalendarPreset.arel_table[:user_id].not_eq(nil))

  def self.presets_for_user(user = nil)
    presets = {}
    CalendarPreset.includes(:calendar_preset_categories).where('user_id = ? or user_id is null', user.try(:id)).each do |preset|
      if (user && preset.user_id == user.id)
        presets[:diy] = preset.calendar_preset_categories.map(&:id)
      else
        presets[preset.id] = preset.calendar_preset_categories.map(&:id)
      end
    end
    presets
  end

end
