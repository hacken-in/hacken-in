class UsersController < ApplicationController
  respond_to :html, :xml

  def show
    if params[:id]
      @user = User.find_by_nickname!(params[:id])
    else
      @user = current_user
    end

    # Collect recent activity of this user:
    @next_events = @user.single_events.today_or_in_future.limit 3
    @recent_comments = @user.comments.recent

    respond_with @user
  end

end

