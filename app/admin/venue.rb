ActiveAdmin.register Venue do
  menu priority: 3
  index do
    column :id
    column :location
    column :street
    column :zipcode
    column :city
    column :country
    column :url
    default_actions
  end

  show do
    h3 venue.location
      div do
        simple_format venue.street
        simple_format venue.zipcode
        simple_format venue.city
        simple_format venue.url
      end
      attributes_table do
      row :single_events do |preset|
        ul do
          venue.single_events.map { |s| li(link_to(s.full_name, edit_admin_event_single_event_path(s.event, s))) }
          end
        end
      row :events do |preset|
        ul do
          venue.events.map { |s| li(link_to(s.name, edit_admin_event_path(s))) }
          end
        end
      end
  end

  form do
    render partial: 'form'
  end
end
