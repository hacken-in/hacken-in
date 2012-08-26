ActiveAdmin.register Picture do
  menu :label => "Bildergallerie"
  index do
    column :title
    column :description
    default_actions
  end
end
