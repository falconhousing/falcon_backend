class CreateFollows < ActiveRecord::Migration
  def change
    create_table :follows do |t|
      t.integer :child_id
      t.integer :parent_id

      t.timestamps
    end
  end
end
