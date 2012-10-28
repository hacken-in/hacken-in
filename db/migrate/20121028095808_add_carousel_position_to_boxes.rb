class AddCarouselPositionToBoxes < ActiveRecord::Migration
  def change
    add_column :boxes, :carousel_position, :integer
  end
end
