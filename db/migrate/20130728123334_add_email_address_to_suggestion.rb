class AddEmailAddressToSuggestion < ActiveRecord::Migration
  def change
    add_column :suggestions, :email_address, :string, limit: 255
  end
end
