# encoding: utf-8

class UserTagsController < ApplicationController
  def create
    @user = User.find params[:user_id]

    if modify_tag_list @user, params[:kind], push: params[:user_tags][:list]
      flash[:notice] = t "user_tags.create.confirmation"
    else
      flash[:error] = t "user_tags.create.error"
    end

    redirect_to :root
  end

  def destroy
    @user = User.find params[:user_id]

    if modify_tag_list @user, params[:kind], remove: params[:id]
      flash[:notice] = t "user_tags.destroy.confirmation"
    else
      flash[:error] = t "user_tags.destroy.error"
    end

    redirect_to :root
  end

  private

  def modify_tag_list(user, kind, action)
    # Only change the currently signed in user
    if current_user == user
      user.modify_tag_list kind, action
      user.save
    end
  end
end
