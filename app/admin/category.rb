# encoding: utf-8
ActiveAdmin.register Category do
  menu priority: 8
  config.sort_order = "title_asc"

  index do
    column :id
    column :title do |p|
      span p.title, style: "color: #{p.color}"
    end
    column :color do |p|
      span p.color, style: "color: #{p.color}"
    end
    default_actions
  end
end
