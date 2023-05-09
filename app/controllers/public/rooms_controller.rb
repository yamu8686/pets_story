class Public::RoomsController < ApplicationController
  def create
    room = Room.create
    current_entry = Entry.create(user_id: current_user.id, room_id: room.id)
    user_entry = Entry.create(user_id: params[:entry][:user_id], room_id: room.id)
    redirect_to room_path(room)
  end

  def show
    @room = Room.find(params[:id])
    @messages = @room.message.all
    @message = Message.new
    @entries = @room.entries
    @user_entry = @entries.where.not(user_id: current_user.id).first
  end
end