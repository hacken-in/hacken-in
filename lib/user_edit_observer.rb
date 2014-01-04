class UserEditObserver < ActiveRecord::Observer
  observe :comment

  def after_update(record)
    changes = record.changes.except(:updated_at)
    if changes.keys.count > 0
      begin
        ChangeMailer.mail_changes(record, changes).deliver
      rescue
      end
    end
  end

  def after_create(record)
    ChangeMailer.mail_create(record).deliver
  end
end
