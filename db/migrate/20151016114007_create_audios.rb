class CreateAudios < ActiveRecord::Migration
  def change
    create_table :audios do |t|
      t.text :file
      t.string :acl
      t.point :coordinates,             :null => false
      t.references :trip, index: true

      t.timestamps
    end
  end
end
