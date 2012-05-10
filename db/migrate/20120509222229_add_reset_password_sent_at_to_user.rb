class AddResetPasswordSentAtToUser < ActiveRecord::Migration
  def change
    unless column_exists? :statuses, :hold_reason
      add_column :users, :reset_password_sent_at, :datetime
    end
  end
end
