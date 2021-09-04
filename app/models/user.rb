class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  attachment :profile_image

  has_many :posts, dependent: :destroy
  has_many :favorites, dependent: :destroy
  has_many :favorited_posts, through: :favorites, source: :post
  has_many :comments, dependent: :destroy

  has_many :active_relationships,  class_name:  "Relationship", foreign_key: "follower_id", dependent:   :destroy
  has_many :passive_relationships, class_name:  "Relationship", foreign_key: "followed_id", dependent:   :destroy

  has_many :following, through: :active_relationships, source: :followed # 自分がフォローしている人
  has_many :followers, through: :passive_relationships, source: :follower # 自分をフォローしている人

  # 通知機能
  has_many :active_notifications, class_name: "Notification", foreign_key: "visiter_id", dependent: :destroy
  has_many :passive_notifications, class_name: "Notification", foreign_key: "visited_id", dependent: :destroy

  # フォローする
  def follow(other_user)
    active_relationships.create(followed_id: other_user.id)
  end

  # フォローを外す
  def unfollow(other_user)
    active_relationships.find_by(followed_id: other_user.id).destroy
  end

  # フォローしているか確認
  def following?(other_user)
    following.include?(other_user)
  end

  # 誕生日の制限
  def birthday_is_valid?
    errors.add(:birthday, "が無効な日付です。") if birthday.nil? || birthday > Date.today
  end

  # ユーザー検索
  def self.search(keyword)
    where(["name like? OR nickname like?", "%#{keyword}%", "%#{keyword}%"])
  end

  # 通知機能（フォロー）
  def create_notification_follow!(current_user)
    temp = Notification.where(["visiter_id = ? and visited_id = ? and kind = ? ", current_user.id, id, 'follow'])
    if temp.blank?
      notification = current_user.active_notifications.new(visited_id: id, kind: 'follow')
      notification.save if notification.valid?
    end
  end

  validates :name, presence: true, length: { maximum: 20 }
  validates :nickname, { presence: true, uniqueness: true, length: { maximum: 20 } }
  validate :birthday_is_valid?
  validates :introduction, length: { maximum: 150 }
end
