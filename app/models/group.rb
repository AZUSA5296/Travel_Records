class Group < ApplicationRecord
  has_many :group_users
  has_many :users, through: :group_users

  validates :name, presence: true, uniqueness: true
  validates :introduction, presence: true
  attachment :image, destroy: false
end
