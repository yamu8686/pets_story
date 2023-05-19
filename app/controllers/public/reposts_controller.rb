class Public::RepostsController < ApplicationController
  before_action :set_post_image

  def create
    if Repost.find_by(user_id: current_user.id, post_image_id: @post_image.id)
      redirect_to public_post_images_path, alert: 'すでにリポスト済みです'
    else
      @repost =  Repost.create(user_id: current_user.id, post_image_id: @post_image.id)
    end
  end

  def destroy
    @repost = current_user.reposts.find_by(post_image_id: @post_image.id)
    if @repost.present?
      @repost.destroy
    else
      redirect_to public_post_images_path, alert: 'すでにリポストを取り消し済みです'
    end
  end

  private

  def set_post_image
    @post_image = PostImage.find(params[:post_image_id])
    if @post_image.nil?
      redirect_to public_post_images_path, alert: '該当の投稿が見つかりません'
    end
  end
end
