class AddIndexToUser < ActiveRecord::Migration
  def change
    change_column "users", :nickname, :string, :default => "", :null => false 
    add_index "users", ["nickname"], :name => "index_users_on_nickname", :unique => true
  end
end
