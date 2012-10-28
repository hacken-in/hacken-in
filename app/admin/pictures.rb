ActiveAdmin.register Picture do
  menu parent: "Content", label: "Bildergallerie"
  index do
    column :id
    column :box_image do |p|
      image_tag p.box_image.url(:thumb)
    end
    column :advertisement_image do |p|
      image_tag p.advertisement_image.url
    end
    column :carousel_image do |p|
      image_tag p.carousel_image.url
    end    
    column :title
    column :description
    default_actions
  end
  show do |ad|
    attributes_table do
      row :id
      row :title
      row :description
      row :box_image do |p|
        image_tag p.box_image.url
      end
      row :advertisement_image do |p|
        image_tag p.advertisement_image.url
      end
      row :carousel_image do |p|
        image_tag p.carousel_image.url
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
  form partial: "picture_form"
end
