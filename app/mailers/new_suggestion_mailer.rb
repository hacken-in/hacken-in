# encoding: utf-8
class NewSuggestionMailer < ActionMailer::Base
  default from: "admin@hacken.in"

  RECIPIENTS = ["admin@hacken.in"]
  SUBJECT = "[hacken.in Vorschlag] Neuer Vorschlag eingereicht!"

  def new_suggestion(record)
    @record = record
    suggestion_mail = mail to: RECIPIENTS, subject: SUBJECT
    suggestion_mail.deliver
  end
end
