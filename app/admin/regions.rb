ActiveAdmin.register Region do
  menu priority: 9
  index do
    column :id
    column :name
    column :slug
    default_actions
  end

  controller do
    with_role :admin
  end
end
