class UsersController < ApplicationController

  def show
    @user = User.find params[:id]

    # Collect recent activity of this user:
    @next_events = @user.single_events.today_or_in_future.limit(3)
    @recent_comments = @user.comments.recent
  end

end

