class Devise20 < ActiveRecord::Migration
  def up
    if column_exists? :users, :remember_token
      remove_column :users, :remember_token
    end
  end

  def down
  end
end
