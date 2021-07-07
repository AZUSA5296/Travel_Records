class CreateNotifications < ActiveRecord::Migration[5.2]
  def change
    create_table :notifications do |t|

      t.integer :post_id
      t.integer :visiter_id
      t.integer :visited_id
      t.integer :comment_id
      t.string :kind
      t.boolean :check, default: false, null: false

      t.timestamps
    end
  end
end
