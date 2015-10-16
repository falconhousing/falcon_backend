class Audio < ActiveRecord::Base
  belongs_to :trip
  belongs_to :cluster
end
