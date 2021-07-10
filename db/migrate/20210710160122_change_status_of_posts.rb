class ChangeStatusOfPosts < ActiveRecord::Migration[5.2]
  def up
    change_column :posts, :status, :boolean, default: 0, null: false
  end

  def down
    change_column :posts, :status, :boolean, default: false, null: false
  end
end