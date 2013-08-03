class AddEmailAddressToSuggestion < ActiveRecord::Migration
  def change
    add_column :suggestions, :email_address, :string
  end
end
