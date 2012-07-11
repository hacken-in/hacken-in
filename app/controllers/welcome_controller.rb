class WelcomeController < ApplicationController
  def index
    @single_events = SingleEvent.in_next(4.weeks).for_user(current_user)
  end
end
