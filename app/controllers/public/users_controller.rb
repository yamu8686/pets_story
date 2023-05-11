class Public::UsersController < ApplicationController
  before_action :authenticate_user!, except: [:index, :show, :edit]
  def index
    @users = User.all
  end

  def show
    @user = User.find(params[:id])
    @post_images = @user.post_images
    @current_entry = Entry.where(user_id: current_user.id)
    @another_entry = Entry.where(user_id: @user.id)
    unless @user.id == current_user.id
      @current_entry.each do |current|
        @another_entry.each do |another|
          if current.room_id == another.room_id
            @isRoom = true
            @roomId = current.room_id
          end
        end
      end
      unless @isoom
        @room = Room.new
        @entry = Entry.new
      end
    end
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    @user.update(user_params)
    redirect_to public_user_path(current_user.id)
  end

  private

  def user_params
    params.require(:user).permit(:name, :profile_image)
  end
end
