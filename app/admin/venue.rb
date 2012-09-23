ActiveAdmin.register Venue do
  menu priority: 11

  index do
    column :location
    column :street
    column :zipcode
    column :city
    column :country
    column :latitude
    column :longitude
    default_actions
  end



  show do
    h3 venue.location
      div do
        simple_format venue.street
        simple_format venue.zipcode
        simple_format venue.city
      end
      attributes_table do
      row :single_events do |preset|
        ul do
          venue.single_events.map { |s| li(link_to(s.name, edit_admin_single_event_path(s))) }
          end
        end  
      row :events do |preset|
        ul do
          venue.events.map { |s| li(link_to(s.name, edit_admin_event_path(s))) }
          end
        end  
      end


  end



end