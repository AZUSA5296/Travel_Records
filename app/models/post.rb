class Post < ApplicationRecord

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :comments, dependent: :destroy
  has_many :notifications, dependent: :destroy

  attachment :image

  # いいね済みか判断する
 def favorited_by?(user)
   favorites.where(user_id: user.id).exists?
 end

  # タグ付け機能
  acts_as_taggable

  # 日付の制限
  def date_is_valid?
    errors.add(:date, "が無効な日付です") if date.present? && date > Date.today
  end

  # 通知機能（いいね）
  def create_notification_by(current_user)
    notification = current_user.active_notifications.new(post_id: id, visited_id: user_id, kind: "favorite")
    notification.save if notification.valid?
  end

  # 通知機能（コメント）
  def create_notification_comment!(current_user, comment_id)
    # 自分以外のコメントしている人を全て取得し、全員に通知を送る
    temp_ids = Comment.select(:user_id).where(post_id: id).where.not(user_id: current_user.id).distinct  # distinctメソッドで、重複レコードを1つにまとめる
    temp_ids.each do |temp_id|
      save_notification_comment!(current_user, comment_id, temp_id['user_id'])
    end
    # 誰もコメントしていない場合は、投稿者に通知を送る
    save_notification_comment!(current_user, comment_id, user_id) if temp_ids.blank?
  end

  def save_notification_comment!(current_user, comment_id, visited_id)
    # 一つの投稿に対して複数回通知をする
    notification = current_user.active_notifications.new(post_id: id, comment_id: comment_id, visited_id: visited_id, kind: 'comment')
    # 自分の投稿に対するコメントを通知済みにする
    if notification.visiter_id == notification.visited_id
      notification.check = true
    end
    notification.save if notification.valid?
  end

  validates :title, presence: true, length: { maximum: 20 }
  validates :image, presence: true
  validate :date_is_valid?
  validates :content, length: { maximum: 1000 }

end
