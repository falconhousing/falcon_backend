class AddClientUuidToUser < ActiveRecord::Migration
  def change
    add_column :users, :client_uuid, :string
  end
end
