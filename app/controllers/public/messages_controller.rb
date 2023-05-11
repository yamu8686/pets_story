class Public::MessagesController < ApplicationController
  before_action :authenticate_user!

  def create
    message = Message.new(message_params)
    message.user_id = current_user.id
    if message.save
      redirect_to public_room_path(message.room)
    else
      redirect_to public_users_path
    end
  end

  private

  def message_params
    params.require(:message).permit(:room_id, :body)
  end
end
