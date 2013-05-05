class DropUnneededData < ActiveRecord::Migration
  def change
    remove_column :pictures, :carousel_image
    remove_column :pictures, :advertisement_image
    drop_table :advertisements
    drop_table :boxes
    drop_table :welcome_contents
  end
end
