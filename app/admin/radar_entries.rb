ActiveAdmin.register RadarEntry do
  filter :region, collection: -> { Region.all }
  filter :event, collection: -> { Event.joins(:radar_settings) }
  filter :state, as: :select, collection: ["UNCONFIRMED", "CONFIRMED"]

  include ActionView::Helpers::SanitizeHelper

  before_filter :only => [:index] do
    if params['commit'].blank?
      params['q'] = {:state_eq => 'UNCONFIRMED'}
    end
  end

  index do
    column :id
    column :event do |entry|
      entry.event.name
    end
    column :entry_date
    column :entry_type
    column :content do |entry|
      if entry.content
        (
          "<p><strong>#{entry.content[:title]}</strong></p>" +
          "#{sanitize entry.content[:description]}" +
          "<p>#{entry.content[:venue]}</p>"
        ).html_safe
      end
    end
    column :actions do |entry|
      link_to(I18n.t('active_admin.view'), resource_path(entry), class: "member_link view_link")
    end
  end

  show partial: 'show'

  member_action :confirm, :method => :get do
    entry = RadarEntry.find(params[:id])
    entry.confirm
    flash.notice = "Bestätigt"
    redirect_to action: :index
  end

end
