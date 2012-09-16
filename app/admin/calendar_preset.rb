ActiveAdmin.register CalendarPreset do
  menu priority: 10
  config.sort_order = "id_asc"

  scope :nerdhub_presets, default: true
  scope :user_presets
  scope :all, :unscoped

  index do
    column :id
    column :title
    column :user do |preset|
        preset.user || 'Nerdhub Preset' 
      end
    column :categories do |preset|
      preset.categories.map { |c| span(c.title, style: "color: #{c.color}") }.join
    end
    default_actions
  end

  show do |preset|
    attributes_table do
      row :id
      row :title
      row :user do |preset|
        preset.user || 'Nerdhub Preset' 
      end
      row :categories do |preset|
        preset.categories.map { |c| span(c.title, style: "color: #{c.color}") }.join
      end
    end
    active_admin_comments
  end

  form partial: "presets_form"

end
