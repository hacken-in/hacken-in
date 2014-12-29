class ChangeVenueDescriptionToText < ActiveRecord::Migration
  def change
    change_column :venues, :description, :text
  end
end
