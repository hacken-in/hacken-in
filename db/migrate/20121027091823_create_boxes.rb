class CreateBoxes < ActiveRecord::Migration
  def change
    create_table :boxes do |t|
      t.integer :content_id
      t.string :content_type
      t.integer :position

      t.timestamps
    end
  end
end
