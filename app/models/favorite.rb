class Favorite < ApplicationRecord

  belongs_to :user
  belongs_to :post

  # 1人が１つの投稿に対して、１つしかいいねをつけられないようにする
  validates_uniqueness_of :post_id, scope: :user_id

end
