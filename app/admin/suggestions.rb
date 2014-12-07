ActiveAdmin.register Suggestion do
  menu priority: 1
  index do
    column :id
    column :email_address
    column :description
    actions
  end

  show do
    attributes_table do
      row :id
      row :email_address
      row :description
    end
  end

  form do |f|
    f.inputs "Suggestion" do
      f.input :id
      f.input :email_address
      f.input :description
      f.buttons
    end
  end

  controller do
    def permitted_params
      params.permit(suggestion: [:email_address, :description])
    end
  end
end
