class RenameFileAtAdvertisement < ActiveRecord::Migration
  def change
    rename_column :advertisements, :file, :picture_id
  end
end
