class User < ActiveRecord::Base
   has_many :trips, :class_name => "Trip"
end
