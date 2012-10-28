class AddAdvertisementPictureToPicture < ActiveRecord::Migration
  def change
    add_column :pictures, :advertisement_image, :string
  end
end
