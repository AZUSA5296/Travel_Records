class ChangePostStatus < ActiveRecord::Migration[5.2]
  def change
    change_column_default :posts, :status, from: false, to: 0
  end
end
