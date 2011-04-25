class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.string :name
      t.text :address
      t.text :description
      t.text :schedule_yaml
      t.string :url

      t.timestamps
    end
   end

  def self.down
    drop_table :events
  end
end
