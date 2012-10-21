class UpgradeImageHandling < ActiveRecord::Migration
  def change
    add_column :blog_posts, :picture_id, :integer
    add_column :single_events, :picture_id, :integer
    add_column :events, :picture_id, :integer

    rename_column :pictures, :image, :box_image
    add_column :pictures, :carousel_image, :string
  end
end
