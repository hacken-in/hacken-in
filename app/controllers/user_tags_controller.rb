# encoding: utf-8

class UserTagsController < ApplicationController

  def create
    @user = User.find(params[:user_id])

    # Only change the currently signed in user
    if current_user == @user
       @user.hate_list << params[:user_hate_tags][:hate_list] if params[:user_hate_tags] && params[:user_hate_tags][:hate_list]
       @user.like_list << params[:user_like_tags][:like_list] if params[:user_like_tags] && params[:user_like_tags][:like_list]

       if @user.save
         flash[:notice] = "Tag hinzugefügt."
       else
         flash[:error] = "Es ist ein Fehler aufgetreten."
       end
    end

    redirect_to :root
  end

  def destroy
    @user = User.find(params[:user_id])

    # Only change the currently signed in user
    if current_user == @user
       @user.send(:"#{params[:kind]}_list").remove params[:id]

       if @user.save
         flash[:notice] = "Tag entfernt."
       else
         flash[:error] = "Es ist ein Fehler aufgetreten."
       end
    end

    redirect_to :root
  end

end
