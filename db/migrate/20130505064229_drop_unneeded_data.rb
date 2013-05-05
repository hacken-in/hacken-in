class DropUnneededData < ActiveRecord::Migration
  def change
    remove_column :pictures, :carousel_image
    remove_column :pictures, :advertisement_image
  end
end
