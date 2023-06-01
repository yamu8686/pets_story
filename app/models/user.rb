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

  def reposted?(post_image_id)
    self.reposts.where(post_image_id: post_image_id).exists?
  end

  def post_images_with_reposts
    relation = PostImage.joins("LEFT OUTER JOIN reposts ON post_images.id = reposts.post_id AND reposts.user_id = #{self.id}")
                   .select("post_images.*, reposts.user_id AS repost_user_id, (SELECT name FROM users WHERE id = repost_user_id) AS repost_user_name")
    relation.where(user_id: self.id)
            .or(relation.where("reposts.user_id = ?", self.id))
            .with_attached_image
            .preload(:user, :comments, :favorites, :reposts)
            .order(Arel.sql("CASE WHEN reposts.created_at IS NULL THEN post_images.created_at ELSE reposts.created_at END"))
  end

  def followings_post_images_with_reposts
    relation = PostImage.joins("LEFT OUTER JOIN reposts ON post_images.id = reposts.post_image_id AND (reposts.user_id = #{self.id} OR reposts.user_id IN (SELECT follow_id FROM relationships WHERE user_id = #{self.id}))")
                   .select("post_images.*, reposts.user_id AS repost_user_id, (SELECT name FROM users WHERE id = repost_user_id) AS repost_user_name")
    relation.where(user_id: self.followings_with_userself.pluck(:id))
            .or(relation.where(id: Repost.where(user_id: self.followings_with_userself.pluck(:id)).distinct.pluck(:post_id)))
            .where("NOT EXISTS(SELECT 1 FROM reposts sub WHERE reposts.post_image_id = sub.post_image_id AND reposts.created_at < sub.created_at)")
            .with_attached_image
            .preload(:user, :comments, :favorites, :reposts)
            .order(Arel.sql("CASE WHEN reposts.created_at IS NULL THEN post_images.created_at ELSE reposts.created_at END"))
  end

  def followings_with_userself
    User.where(id: self.followings.pluck(:id)).or(User.where(id: self.id))
  end
end
