class ApiController < ApplicationController

  RADIUS = 500

  def results
    binding.pry
    # lat_lng = params["lat_lng"] 
    lat_lng = "72.0,19.0"
    audios = Audio.scoped
    audios = apply_radius_filter(audios,lat_lng,RADIUS)
    binding.pry
    audios = audios.where("acl = 'public' OR ( acl = 'friends' and user_id in #{get_my_friends} ) ")

    posts = audios.all # all matching posts

    binding.pry
    p "hello"

  end

  private

  def get_my_friends
    [1,2,3,4,5] #list of friend_ids
  end

  def apply_radius_filter(audios, lat_lng, radius)
    lat_lng = lat_lng.split(",")
    if lat_lng.length == 2
      sql_args = (lat_lng.reverse + [radius])
      point_circle = "ST_Transform(ST_Buffer(ST_Transform(ST_SetSRID(ST_MakePoint(%s, %s), 4326), 3785), %s), 4326)" % sql_args
      audios = audios.where("st_intersects(%s, audios.coordinates)" % point_circle)
    end
    return audios
  end


end