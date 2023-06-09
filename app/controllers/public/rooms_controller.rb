class Public::RoomsController < ApplicationController
  before_action :authenticate_user!

  def create
    room = Room.create
    @current_entry = Entry.create(user_id: current_user.id, room_id: room.id)
    @user_entry = Entry.create(user_id: params[:entry][:user_id], room_id: room.id)
    redirect_to public_room_path(room)
  end

  def index
    current_entries = current_user.entries
    my_room_id = []
    current_entries.each do |entry|
      my_room_id << entry.room.id
    end
    @another_entries = Entry.where(room_id: my_room).where.not(user_id: current_user.id)
  end

  def show
    @room = Room.find(params[:id])
    @messages = @room.messages
    @message = Message.new
    @entries = @room.entries
    @user_entry = @entries.where.not(user_id: current_user.id).first
  end
end