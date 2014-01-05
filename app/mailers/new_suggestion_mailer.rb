# encoding: utf-8
class NewSuggestionMailer < ActionMailer::Base
  default from: "bodo@wannawork.de"

  RECIPIENTS = ["bodo@wannawork.de", "lucas.dohmen@koeln.de"]
  SUBJECT = "[hacken.in Vorschlag] Neuer Vorschlag eingereicht!"

  def new_suggestion(record)
    @record = record
    suggestion_mail = mail to: RECIPIENTS, subject: SUBJECT
    suggestion_mail.deliver
  end
end
