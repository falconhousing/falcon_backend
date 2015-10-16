class ApiController < ApplicationController
  include AudiosHelper
  
  RADIUS = 500

  def results
    # lat_lng = params["lat_lng"] 
    lat_lng = "19.0,72.0"
    audios = Audio.scoped
    audios = apply_radius_filter(audios,lat_lng,RADIUS)
    sql = "acl = 'public' OR ( acl = 'friends' and user_id in (?)) OR user_id = ?", get_my_friends, current_user_id
    audios = audios.where(sql)
    audios = audios.joins{user}.select("audios.*,users.id as user_id,users.name") # all matching posts
    posts = audios.as_json
    posts = add_url(posts, audios)
    render json: posts
  end

  private

  def current_user_id
    1
  end
  
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