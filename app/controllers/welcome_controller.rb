class WelcomeController < ApplicationController

  def index
    @single_events = SingleEvent.getNextWeeks 4

    if user_signed_in? && !current_user.hate_list.empty?
      @single_events.delete_if do |single_event|
        ((single_event.event.tag_list & current_user.hate_list).length > 0 &&
        (!single_event.users.include? current_user))
       end
    end
  end

  def abonnieren
    @general_link = url_for( :action => "general", :controller => "ical", :format => "ical", :only_path => false )
    @personal_link = url_for( :action => "personalized", :controller => "ical", :format => "ical", :only_path => false, :guid => current_user.guid )  if user_signed_in?
  end

end
