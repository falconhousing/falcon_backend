class User < ActiveRecord::Base
   has_many :audios, :class_name => "Audio"
end
