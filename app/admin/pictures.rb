ActiveAdmin.register Picture do
  menu priority: 4, label: "Bildergallerie"
  index do
    column :id
    column :image do |p|
      image_tag p.image.url(:thumb)
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
      row :image do |p|
        image_tag p.image.url
      end
      row :created_at
      row :updated_at
    end
    active_admin_comments
  end
  form partial: "picture_form"
  #form do |f|
    #f.inputs "Bild" do
      #f.input :title
      #f.input :description
      #div do
        #image_tag @post.image.url
      #end
      #f.input :image
    #end
    #f.buttons
  #end
end
