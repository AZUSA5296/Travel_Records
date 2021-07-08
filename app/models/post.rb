class Post < ApplicationRecord

  belongs_to :user
  attachment :image

end
