class UserEditObserver < ActiveRecord::Observer
  observe :comment

  def before_save(record)
    if !record.new_record?
      record.instance_variable_set(:@user_edit_observer_old_state, record.class.find(record.id).to_json)
    end
  end

  def after_update(record)
    changes = record.changes.except(:updated_at)
    if changes.keys.count > 0
      ChangeMailer.mail_changes(record, changes).deliver
    end
  end

  def after_create(record)
    ChangeMailer.mail_create(record).deliver
  end
end
