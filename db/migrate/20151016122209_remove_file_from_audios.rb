class RemoveFileFromAudios < ActiveRecord::Migration
  def change
    remove_column :audios, :file, :text
  end
end
