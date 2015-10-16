class Audio < ActiveRecord::Base
  belongs_to :user
  belongs_to :cluster
  has_attached_file :audio
  FACTORY = RGeo::Geographic.simple_mercator_factory
  set_rgeo_factory_for_column(:coordinates, FACTORY)
  validates_attachment :audio, :content_type => { :content_type => ["audio/mp3","audio/mpeg","audio/3gpp"] }
  validates_attachment_presence :audio
  
  validates_inclusion_of :acl, :in => ["friends", "me", "public"], :allow_nil => false
  
end
