class Public::RelationshipsController < ApplicationController

  def create
    current_user.follow(params[:user_id])
  end

  def destroy
    current_user.unfollow(params[:user_id])
  end

end
