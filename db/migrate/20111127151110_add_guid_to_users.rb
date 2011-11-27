class AddGuidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :guid, :string, :unique => true
  end
end
