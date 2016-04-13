ActiveAdmin.register RegionSlug do
  menu priority: 10
  index do
    column :id
    column :slug
    column :region
    column :main_slug
    actions
  end

  controller do
    def permitted_params
      params.permit(region_slug: [:slug, :region_id, :main_slug])
    end
  end
end
