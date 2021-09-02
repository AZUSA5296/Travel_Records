class Group < ApplicationRecord
  has_many :group_users
  has_many :users, through: :group_users

  validates :name, presence: true, uniqueness: true, length: { maximum: 20 }
  validates :introduction, length: { maximum: 1000 }
  attachment :image, destroy: false
end
