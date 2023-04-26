class Public::PostImagesController < ApplicationController
  def new
    @post_image = PostImage.new
  end

  def create
    @post_image = PostImage.new(post_image_params)
    @post_image.user_id = current_user.id
    @post_image.save
    redirect_to public_post_images_path
  end

  def index
    @post_images = PostImage.all
  end

  def show
  end

  def edit
  end

  def destroy
  end

  private

  def post_image_params
    params.require(:post_image).permit(:name, :image, :description)
  end
end
