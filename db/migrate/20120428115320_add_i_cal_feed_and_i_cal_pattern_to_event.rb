class AddICalFeedAndICalPatternToEvent < ActiveRecord::Migration
  def change
    add_column :events, :ical_feed, :string
    add_column :events, :ical_pattern, :string
  end
end
