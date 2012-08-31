# encoding: utf-8

class UserTagsController < ApplicationController
  def create
    @user = User.find params[:user_id]


    if modify_tag_list @user, params[:kind], chosen_list(params[:kind])
      flash[:notice] = t "user_tags.create.confirmation"
    else
      flash[:error] = t "user_tags.create.error"
    end

    redirect_to :root
  end

  def destroy
    @user = User.find params[:user_id]

    if remove_tag_from_list @user, params[:kind], remove: params[:id]
      flash[:notice] = t "user_tags.destroy.confirmation"
    else
      flash[:error] = t "user_tags.destroy.error"
    end

    redirect_to :root
  end

  private

  def chosen_list(kind)
    if kind == "like"
      params[:user_like_tags][:list]
    else
      params[:user_hate_tags][:list]
    end
  end

  def modify_tag_list(user, kind, action)
    # Only change the currently signed in user
    actions = action.split(",")
    actions.each do |a|
      if current_user == user
        user.modify_tag_list kind, push: a
        user.save
      end
    end
  end

  def remove_tag_from_list(user, kind, action)
    # Only change the currently signed in user
    if current_user == user
      user.modify_tag_list kind, action
      user.save
    end
  end
end
