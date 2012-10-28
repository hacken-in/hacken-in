# encoding: utf-8
class UserTagsController < ApplicationController
  def create
    return render(:nothing => true, :status => :unauthorized) unless current_user

    if modify_tag_list params[:kind], params[:tags]
      render json: { :status => :success, :message => t("user_tags.create.confirmation") }, :status => :created
    else
      render json: { :status => :error, :message => t("user_tags.create.error") }, :status => 422 #TODO: Eventuell besseren Code verwenden ;)
    end
  end

  def destroy
    return render(:nothing => true, :status => :unauthorized) unless current_user

    if remove_tag_from_list params[:kind], remove: params[:id]
      render json: { :status => :success, :message => t("user_tags.destroy.confirmation") }, :status => :ok
    else
      render json: { :status => :error, :message => t("user_tags.destroy.error") }, :Status => 422 #TODO s.o.
    end
  end

  private

  def modify_tag_list(kind, action)
    actions = action.split(",")
    actions.each do |a|
      current_user.modify_tag_list kind, push: a
      current_user.save
    end
  end

  def remove_tag_from_list(kind, action)
    current_user.modify_tag_list kind, action
    current_user.save
  end
end
