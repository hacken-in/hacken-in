class CreateThisiscolognes < ActiveRecord::Migration
  def change
    create_table :thisiscologne_pictures do |t|
      t.string :description
      t.string :image_url
      t.string :link
      t.datetime :time

      t.timestamps
    end

    add_index :thisiscologne_pictures, :image_url, unique: true
  end
end
