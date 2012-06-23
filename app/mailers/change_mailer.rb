# encoding: utf-8
class ChangeMailer < ActionMailer::Base
  default :from => "bodo@hcking.de"

  RECIPIENTS = ["bodo@wannawork.de", "lucas.dohmen@koeln.de"]

  def mail_changes(record, changes)
    @record = record
    @changes = changes
    mail(:to => RECIPIENTS, :subject => "[hcking.de notify] Änderungen an #{record.class.to_s} # #{record.id}")
  end

  def mail_create(record)
    @record = record
    mail(:to => RECIPIENTS, :subject => "[hcking.de notify] Neuer #{record.class.to_s} # #{record.id}")
  end
end
