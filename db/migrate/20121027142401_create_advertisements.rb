class CreateAdvertisements < ActiveRecord::Migration
  def change
    create_table :advertisements do |t|
      t.string :file
      t.string :link
      t.text :description
      t.string :calendar_week
      t.datetime :from
      t.datetime :to
      t.boolean :active
      t.integer :duration

      t.timestamps
    end
  end
end
