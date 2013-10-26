ActiveAdmin.register User do
  menu priority: 6
  index do
    column :id
    column :nickname
    column :email
    column :admin
    column :description do |user|
      user.description.truncate 80 unless user.description.blank?
    end
    column :github
    column :twitter
    column :homepage
    default_actions
  end

  form do
    render partial: 'form'
  end

  show do
    attributes_table do
      row :id
      row :nickname
      row :name
      row :email
      row :current_sign_in_at
      row :admin
      row :current_region
      row :assigned_regions do |u|
        raw u.assigned_regions.map { |region| link_to region.name, admin_region_path(region) }.join(', ')
      end
      row :curated_events do |u|
        raw u.curated_events.map { |event| link_to event.title, admin_event_path(title) }.join(', ')
      end
    end
  end


  controller do
    with_role :admin
    defaults finder: :find_by_nickname

    def permitted_params
      params.permit(user: %i[
        nickname
        email
        admin
        description
        github
        twitter
        homepage
      ])
    end
  end

end
