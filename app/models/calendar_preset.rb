class CalendarPreset < ActiveRecord::Base
  attr_accessible :title, :user, :categories, :user_id, :category_ids

  belongs_to :user
  has_many :calendar_preset_categories
  has_many :categories, :through => :calendar_preset_categories

  scope :hacken_presets, where(CalendarPreset.arel_table[:user_id].eq(nil))
  scope :user_presets, where(CalendarPreset.arel_table[:user_id].not_eq(nil))

  # Diese Funktion sammelt alle für den Benutzer relevanten CalendarPresets ein,
  # dazu gehören Hacken.in Presets (user id = nil) sowie das Preset für den Benutzer
  # Wenn es für den Benutzer kein Preset gibt, wird für ihn ein neues Preset angelegt
  def self.presets_for_user(user = nil)

    CalendarPreset.find_or_create_by_user_id(user.id) if user

    presets = { diy: [] }
    CalendarPreset.includes(:calendar_preset_categories).where('user_id = ? or user_id is null', user.try(:id)).each do |preset|
      key = (user && preset.user_id == user.id) ? :diy : preset.id
      presets[key] = preset.calendar_preset_categories.map(&:category_id)
    end
    presets
  end

  def title
    read_attribute(:title) || 'DIY'
  end

end
