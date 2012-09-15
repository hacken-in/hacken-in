class DeleteAdminUser < ActiveRecord::Migration
  def up
    drop_table :admin_users if ActiveRecord::Base.connection.tables.include?("admin_users")
  end

  def down
  end
end
