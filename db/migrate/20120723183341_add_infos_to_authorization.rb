class AddInfosToAuthorization < ActiveRecord::Migration
  def change
    add_column :authorizations, :token, :string
    add_column :authorizations, :secret, :string
    add_column :authorizations, :token_expires, :datetime
  end
end
