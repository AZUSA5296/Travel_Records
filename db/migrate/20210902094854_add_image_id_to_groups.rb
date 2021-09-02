class AddImageIdToGroups < ActiveRecord::Migration[5.2]
  def change
    add_column :groups, :image_id, :string
  end
end
