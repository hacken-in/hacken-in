ActiveAdmin.register Region do
  menu priority: 9
  index do
    column :id
    column :name
    column :slug
    column :active
    actions
  end

  controller do
    def permitted_params
      params.permit(region: [:name, :slug, :latitude, :longitude, :perimeter, :active])
    end
  end
end
