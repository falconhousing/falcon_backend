class FixSchema < ActiveRecord::Migration
  def change
    rename_column :audios, :trip_id, :user_id
  end
end
