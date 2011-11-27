class AddAllowIgnoreViewToUsers < ActiveRecord::Migration
  def change
    add_column :users, :allow_ignore_view, :Boolean
  end
end
