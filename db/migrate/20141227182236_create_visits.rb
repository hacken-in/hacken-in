class CreateVisits < ActiveRecord::Migration
  def change
    create_table :visits, id: false do |t|
      t.uuid :id, primary_key: true
      t.uuid :visitor_id

      # standard
      t.string :ip, limit: 255
      t.text :user_agent
      t.text :referrer
      t.text :landing_page

      # user
      t.integer :user_id

      # traffic source
      t.string :referring_domain, limit: 255
      t.string :search_keyword, limit: 255

      # technology
      t.string :browser, limit: 255
      t.string :os, limit: 255
      t.string :device_type, limit: 255

      # location
      t.string :country, limit: 255
      t.string :region, limit: 255
      t.string :city, limit: 255

      # utm parameters
      t.string :utm_source, limit: 255
      t.string :utm_medium, limit: 255
      t.string :utm_term, limit: 255
      t.string :utm_content, limit: 255
      t.string :utm_campaign, limit: 255

      # native apps
      t.string :platform, limit: 255
      t.string :app_version, limit: 255
      t.string :os_version, limit: 255

      t.timestamp :started_at
    end

    add_index :visits, [:user_id]
  end
end
