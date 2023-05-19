class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

          has_many :post_images, dependent: :destroy

          has_many :post_comments, dependent: :destroy

          has_many :favorites, dependent: :destroy
          has_many :favorited_post_images, through: :favorites, source: :post_image

          has_many :relationships, class_name: "Relationship", foreign_key: "follower_id", dependent: :destroy
          has_many :reverse_of_relationships, class_name: "Relationship", foreign_key: "followed_id", dependent: :destroy

          has_many :followings, through: :relationships, source: :followed
          has_many :followers, through: :reverse_of_relationships, source: :follower

          has_many :messages, dependent: :destroy
          has_many :entries, dependent: :destroy

          has_many :reposts, dependent: :destroy

          has_one_attached :profile_image

  def get_profile_image(width, height)
    unless profile_image.attached?
      file_path = Rails.root.join('app/assets/images/no_image.jpg')
      profile_image.attach(io: File.open(file_path), filename: 'default-image.jpg', content_type: 'image/jpeg')
    end
    profile_image.variant(resize_to_limit: [width, height]).processed
  end

  def follow(user_id)
    relationships.find_or_create_by(followed_id: user_id)
  end

  def unfollow(user_id)
    follow = relationships.find_by(followed_id: user_id)
    follow.destroy if follow
  end

  def following?(user)
    followings.include?(user)
  end
end
