class AddTempTokenToAuthorizations < ActiveRecord::Migration
  def change
    add_column :authorizations, :temp_token, :string
  end
end
