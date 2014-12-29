ActiveAdmin.register Picture do
  menu priority: 4
  index do
    column :id
    column :box_image do |p|
      image_tag p.box_image.url(:thumb)
    end
    column :title
    column :description
    actions
  end
  show do |ad|
    attributes_table do
      row :id
      row :title
      row :description
      row :box_image do |p|
        image_tag p.box_image.url
      end
      row :created_at
      row :updated_at
    end
  end
  form partial: "picture_form"

  controller do
    def permitted_params
      params.permit(picture: [:box_image, :title, :description])
    end
  end
end
