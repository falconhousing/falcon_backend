class Trip < ActiveRecord::Base
  belongs_to :user
  has_many :audios, :class_name => "Audio"
end
