class CreateTrips < ActiveRecord::Migration
  def change
    create_table :trips do |t|
      t.string :name
      t.text :title
      t.references :user, index: true

      t.timestamps
    end
  end
end
