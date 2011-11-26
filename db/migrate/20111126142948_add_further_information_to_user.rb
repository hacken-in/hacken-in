class AddFurtherInformationToUser < ActiveRecord::Migration
  def change
    add_column :users, :description, :text
    add_column :users, :github, :string
    add_column :users, :twitter, :string
    add_column :users, :homepage, :string
  end
end
