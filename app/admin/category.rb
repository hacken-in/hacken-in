ActiveAdmin.register Category do
  index do
    column :title do |p|
      span p.title, style: "color: #{p.color}"
    end
    column :color do |p|
      span p.color, style: "color: #{p.color}"
    end
    default_actions
  end
end
