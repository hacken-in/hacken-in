class WelcomeController < ApplicationController
  caches_action :index, :expires_in => 10.minutes, :if => Proc.new{ !(can?(:create, Event)) }

  def index
    @single_events = SingleEvent.getNextWeeks 4

    # Todo: Remove SingleEvents that are hated
    #if user_signed_in? && !current_user.hate_list.empty?
    #  @events = Event.tagged_with(current_user.hate_list, exclude: true).get_ordered_events(Date.today, Date.today + 4.weeks)
    #else
    #  @events = Event.get_ordered_events(Date.today, Date.today + 4.weeks)
    #end
  end

end
