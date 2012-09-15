class DeleteAdminUser < ActiveRecord::Migration
  def up
    drop_table :admin_users
  end

  def down
  end
end
