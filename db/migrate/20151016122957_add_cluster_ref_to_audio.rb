class AddClusterRefToAudio < ActiveRecord::Migration
  def change
    add_reference :audios, :cluster, index: true
  end
end
