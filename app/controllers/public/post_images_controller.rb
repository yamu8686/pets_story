class Public::PostImagesController < ApplicationController
  before_action :authenticate_user!, except: [:new, :index, :show, :edit]

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
    #@post_images = PostImage.all
    @post_images = PostImage.includes(:favorited_users).sort {|a,b| b.favorited_users.size <=> a.favorited_users.size}
    if user_signed_in?
      @user = User.find(current_user.id)
      @post_images = @user.followings_post_images_with_reposts
    else
      @post_images = PostImage.with_attached_images.preload(:user, :comments, :favorites)
    end
  end

  def show
    @post_image = PostImage.find(params[:id])
    @post_comment = PostComment.new
  end

  def edit
    @post_image = PostImage.find(params[:id])
  end

  def update
    @post_image = PostImage.find(params[:id])
    @post_image.update(post_image_params)
    redirect_to public_post_image_path(@post_image.id)
  end

  def destroy
    post_image = PostImage.find(params[:id])
    post_image.destroy
    redirect_to public_post_images_path
  end

  private

  def post_image_params
    params.require(:post_image).permit(:name, :image, :description)
  end
end
