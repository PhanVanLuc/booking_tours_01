class AddTagToTours < ActiveRecord::Migration[6.1]
  def change
    add_column :tours, :tag, :integer
  end
end
