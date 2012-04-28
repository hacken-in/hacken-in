class Devise20 < ActiveRecord::Migration
  def up
    remove_column :users, :remember_token
  end

  def down
  end
end
