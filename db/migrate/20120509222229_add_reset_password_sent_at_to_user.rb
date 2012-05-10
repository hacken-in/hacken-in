class AddResetPasswordSentAtToUser < ActiveRecord::Migration
  def change
    unless column_exists? :users, :reset_password_sent_at
      add_column :users, :reset_password_sent_at, :datetime
    end
  end
end
