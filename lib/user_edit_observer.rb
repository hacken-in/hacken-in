class UserEditObserver < ActiveRecord::Observer
  observe :comment, :event, :single_event

  def before_save(record)
    if !record.new_record?
      record.instance_variable_set(:@user_edit_observer_old_state, record.class.find(record.id).to_json)
    end
  end

  def after_update(record)
    changes = record.changes.except(:latitude, :longitude, :updated_at)
    if changes.keys.count > 0
      begin
        ChangeMailer.mail_changes(record, changes).deliver
      rescue
      end
    end
  end

  def after_create(record)
    if (record.kind_of?(SingleEvent) && (record.based_on_rule == false)) || !record.kind_of?(SingleEvent)
      begin
        ChangeMailer.mail_create(record).deliver
      rescue
      end
    end
  end
end
