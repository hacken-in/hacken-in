class UsersController < ApplicationController
  respond_to :html, :xml

  def show
    @user = User.find_by_nickname!(params[:id])

    # Collect recent activity of this user:
    @next_events = @user.single_events.today_or_in_future.limit 3
    @recent_comments = @user.comments.recent

    respond_with @user
  end

end

