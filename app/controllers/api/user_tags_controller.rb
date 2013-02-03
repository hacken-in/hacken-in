# encoding: utf-8
class Api::UserTagsController < ApplicationController
  def create
    return render(:nothing => true, :status => :unauthorized) unless current_user

    if modify_tag_list params[:kind], params[:tags]
      render json: { :status => :success, :message => t("user_tags.create.confirmation") }, :status => :created
    else
      render json: { :status => :error, :message => t("user_tags.create.error") }, :status => 422
    end
  end

  def destroy
    return render(:nothing => true, :status => :unauthorized) unless current_user

    if remove_tag_from_list params[:kind], params[:id]
      render json: { :status => :success, :message => t("user_tags.destroy.confirmation") }, :status => :ok
    else
      render json: { :status => :error, :message => t("user_tags.destroy.error") }, :Status => 422
    end
  end

  private

  def modify_tag_list(kind, tags)
    tags.split(",").each do |tag|
      if (kind == "hate")
        current_user.like_list.remove tag
        current_user.hate_list << tag
      else
        current_user.hate_list.remove tag
        current_user.like_list << tag
      end
      current_user.save
    end
  end

  def remove_tag_from_list(kind, tag)
    if (kind == "hate")
      current_user.hate_list.remove tag
    else
      current_user.like_list.remove tag
    end
    current_user.save
  end

end
