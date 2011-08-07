class WelcomeController < ApplicationController
  caches_action :index, :if => Proc.new{ !(can?(:create, Event)) }

  def index
    
  end

end
