class CreatePosts < ActiveRecord::Migration[5.2]
  def change
    create_table :posts do |t|

      t.integer :user_id
      t.string :title
      t.text :content
      t.date :date
      t.string :image_id
      t.boolean :status, default: 0, null: false

      t.timestamps
    end
  end
end
