# encoding: utf-8
class NewSuggestionMailer < ActionMailer::Base
  default from: "bodo@wannawork.de"

  RECIPIENTS = ["bodo@wannawork.de", "lucas.dohmen@koeln.de", "klaus.zanders@gmail.com"]

  def new_suggestion(record)
    @record = record
    mail to: RECIPIENTS, subject: "[hcking.de Vorschlag] Neuer Vorschlag eingereicht!"
  end

end
