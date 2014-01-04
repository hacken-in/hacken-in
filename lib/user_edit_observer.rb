class UserEditObserver < ActiveRecord::Observer
  observe :comment

  def after_update(record)
    ChangeMailer.mail_changes(record, record.changes) if record.content_changed?
  end

  def after_create(record)
    ChangeMailer.mail_create(record)
  end
end
