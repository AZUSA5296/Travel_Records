class Post < ApplicationRecord

  belongs_to :user
  has_many :favorites, dependent: :destroy
  has_many :favorited_users, through: :favorites, source: :user
  has_many :comments, dependent: :destroy

  attachment :image

  #いいね済みか判断する
 def favorited_by?(user)
   favorites.where(user_id: user.id).exists?
 end

  #タグ付け機能
  acts_as_taggable

end
