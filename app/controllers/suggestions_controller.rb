class SuggestionsController < ApplicationController
  respond_to :html, :xml

  def new
    @suggestion = Suggestion.new
    respond_with @suggestion
  end

  def show
    @suggestion = Suggestion.find params[:id]
    respond_with @suggestion
  end

  def create
    @suggestion = Suggestion.new(suggestion_params)

    if verify_recaptcha(:model => @suggestion)
      if @suggestion.save
        NewSuggestionMailer.new_suggestion(@suggestion)
        redirect_to :root, flash: {notice: t("suggestions.create.confirmation")}
      else
        render :new
      end
    else
      flash[:error] = t("suggestions.create.wrong_recaptcha")
      render :new
    end
  end

  def suggestion_params
    params.require(:suggestion).permit(:email_address, :description)
  end
end
