ActiveAdmin.register Tag do
  menu priority: 9
  config.sort_order = "name_asc"
  controller do
    defaults finder: :find_by_name
  end
  index do
    column :id
    column :name do |p|
      span p.name, style: "color: #{p.category.try(:color) || "#000"}"
    end
    column :category do |p|
      span p.category.try(:title), style: "color: #{p.category.try(:color) || "#000"}"
    end
    default_actions
  end
end
