class AddSessionTokenToSingleEventExternalUsers < ActiveRecord::Migration
  def change
    add_column :single_event_external_users, :session_token, :string, after: :email
  end
end
