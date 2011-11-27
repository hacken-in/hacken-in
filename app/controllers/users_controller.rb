class UsersController < ApplicationController
  
  def show
    @user = User.find params[:id]
    
    # Collect recent activity of this user:
    @recent_events = @user.single_events.recent
    @recent_comments = @user.comments.recent
    
  end
  
end

