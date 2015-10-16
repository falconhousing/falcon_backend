class ChangeAudioFileTypeInAudio < ActiveRecord::Migration
    def up
      add_attachment :audios, :audio
      remove_column :audios, :audio_file
    end

    def down
      remove_attachment :audios, :audio
    end
end
