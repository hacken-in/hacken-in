class AddFurtherInformationToUser < ActiveRecord::Migration
  def change
    add_column :users, :description, :Text
    add_column :users, :github, :String
    add_column :users, :twitter, :String
    add_column :users, :homepage, :String
  end
end
