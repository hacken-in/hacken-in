ActiveAdmin.register Region do
  menu priority: 9
  index do
    column :id
    column :name
    column :active
    column :region_slugs do |region|
      region.region_slugs.pluck(:slug).join(', ')
    end
    actions
  end

  controller do
    def permitted_params
      params.permit(region: [:name, :latitude, :longitude, :perimeter, :active])
    end
  end
end
