class FixAdvertisementTable < ActiveRecord::Migration
  def change
    remove_column :advertisements, :from
    remove_column :advertisements, :to
    change_column :advertisements, :calendar_week, :integer
  end
end
