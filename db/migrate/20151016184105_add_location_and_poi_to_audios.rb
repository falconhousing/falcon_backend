class AddLocationAndPoiToAudios < ActiveRecord::Migration
  def change
    add_column :audios, :location, :string
    add_column :audios, :poi, :string
  end
end
