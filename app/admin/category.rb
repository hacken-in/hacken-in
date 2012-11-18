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
    column :blog_category do |p|
      p.blog_category ? "✓" : "-"
    end
    column :calendar_category do |p|
      p.calendar_category ? "✓" : "-"
    end
    column :podcast_category do |p|
      p.podcast_category ? "✓" : "-"
    end
    default_actions
  end


end
