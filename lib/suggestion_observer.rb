class SuggestionObserver < ActiveRecord::Observer
  observe :suggestion

  def after_create(record)
    NewSuggestionMailer.new_suggestion(record).deliver
  end

end
