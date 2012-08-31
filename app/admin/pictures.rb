ActiveAdmin.register Picture do
  menu :label => "Bildergallerie"
  index do
    column :image do |p|
      image_tag p.image.url(:thumb)
    end
    column :title
    column :description
    default_actions
  end
end
