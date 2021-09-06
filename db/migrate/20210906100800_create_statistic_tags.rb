class CreateStatisticTags < ActiveRecord::Migration[6.1]
  def change
    create_table :statistic_tags do |t|
      t.integer :tag_id

      t.timestamps
    end
  end
end
