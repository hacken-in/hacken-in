class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.text    :body
      t.integer :user_id
      t.integer :commentable_id
      t.string  :commentable_type
      t.timestamps
    end
    add_index :comments, [:commentable_id, :commentable_type]
  end
end
