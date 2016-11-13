ActiveAdmin.register User do
  filter :id
  filter :email
  filter :nickname
  filter :admin

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
    actions
  end

  form partial: 'form'

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

  action_item only: :edit do
    link_to 'Send password reset email.', send_password_reset_link_admin_user_path(user.id), :method => :post
  end

  controller do
    defaults finder: :find_by_nickname

    def permitted_params
      params.permit(user: [
        :nickname,
        :email,
        :admin,
        :description,
        :github,
        :twitter,
        :homepage,
        :team,
        :name,
        {
          assigned_region_ids: [],
          curated_event_ids: []
        }
      ])
    end
  end

  member_action :send_password_reset_link, method: :post do
    user = User.find(params[:id])
    user.send_reset_password_instructions
    flash[:notice] = "Password reset instructions where sent to #{user.email}."
    redirect_to edit_admin_user_path(user)
  end
end
