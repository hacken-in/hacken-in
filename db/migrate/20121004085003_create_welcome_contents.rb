class CreateWelcomeContents < ActiveRecord::Migration
  def change
    create_table :welcome_contents do |t|
      t.text :box_1
      t.text :box_2
      t.text :box_3
      t.text :box_4
      t.text :box_5
      t.text :box_6
      t.text :carousel

      t.timestamps
    end
  end
end
