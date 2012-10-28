class RenamePositionToGridPosition < ActiveRecord::Migration
  def change
    rename_column :boxes, :position, :grid_position
  end
end
