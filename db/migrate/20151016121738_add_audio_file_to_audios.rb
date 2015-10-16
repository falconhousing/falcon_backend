class AddAudioFileToAudios < ActiveRecord::Migration
  def change
    add_column :audios, :audio_file, :string
  end
end
