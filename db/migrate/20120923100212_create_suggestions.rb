class CreateSuggestions < ActiveRecord::Migration
  def change
    create_table :suggestions do |t|
      t.string :name
      t.string :occurrence
      t.text :description
      t.text :place
      t.text :more

      t.timestamps
    end
  end
end
