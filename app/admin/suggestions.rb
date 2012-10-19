ActiveAdmin.register Suggestion do
  menu parent: "Kalender"
  index do
    column :id
    column :name
    column :occurrence
    column :description
    column :more_as_inline
    column :place
    default_actions
  end

  show do
    attributes_table do
      row :id
      row :name
      row :occurrence
      row :description
      row :more_as_inline
      row :place
    end
  end

  form do |f|
    f.inputs "Suggestion" do
      f.input :id
      f.input :name
      f.input :occurrence
      f.input :description
      f.input :more_as_text, as: "text"
      f.input :place
      f.buttons
    end
  end
end
