class WelcomeController < ApplicationController
  caches_action :index, :expires_in => 10.minutes, :if => Proc.new{ !(can?(:create, Event)) }

  def index
    @single_events = SingleEvent.getNextWeeks 4
  end

end
