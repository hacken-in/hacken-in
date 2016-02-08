ActiveAdmin.register Venue do

  filter :location
  filter :region
  filter :locatoin
  filter :street
  filter :zipcode
  filter :city
  filter :country
  filter :url

  menu priority: 3
  index do
    column :id
    column :location
    column :street
    column :zipcode
    column :city
    column :country
    column :url do |venue|
      link_to truncate(venue.url, length: 30), venue.url
    end
    actions
  end

  show do
    h3 venue.location
    div do
      venue.street
    end
    div do
      venue.zipcode + " " + venue.city
    end
    div do
      "<a href='#{venue.url}'>#{venue.url}</a>".html_safe
    end
    div do
      "<a class='map-link' href='http://maps.google.com/maps?z=18&q=#{venue.latitude},#{venue.longitude}' data-lat='#{venue.latitude}' data-lng='#{venue.longitude}'>Google Maps</a>".html_safe
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

  form partial: 'form'

  controller do
    def permitted_params
      params.permit(venue: [
        :location,
        :street,
        :zipcode,
        :city,
        :country,
        :url,
        :region_id
      ])
    end
  end
end
