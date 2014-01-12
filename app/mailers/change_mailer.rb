# encoding: utf-8
class ChangeMailer < ActionMailer::Base
  default from: "admin@hacken.in"

  RECIPIENTS = ["admin@hacken.in"]

  def mail_changes(record, old_content)
    @record = record
    @old_content = old_content
    @new_content = @record.body
    changes_mail = mail to: RECIPIENTS, subject: "[hacken.in notify] Änderungen an #{record.class.to_s} # #{record.id}"
    changes_mail.deliver
  end

  def mail_create(record)
    @record = record
    created_mail = mail to: RECIPIENTS, subject: "[hacken.in notify] Neuer #{record.class.to_s} # #{record.id}"
    created_mail.deliver
  end
end
