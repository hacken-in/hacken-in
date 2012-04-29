class AddHashToEvent < ActiveRecord::Migration
  def change
    add_column :events, :ical_hash, :string
  end
end
