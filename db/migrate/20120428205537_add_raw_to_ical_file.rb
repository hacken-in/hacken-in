class AddRawToIcalFile < ActiveRecord::Migration
  def change
    add_column :ical_files, :raw, :text
  end
end
