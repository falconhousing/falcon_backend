class ApiController < ApplicationController
  include AudiosHelper

  PERMISSION = true

  before_filter do |controller|
    if PERMISSION
      validate_session
    end
  end

  def validate_session
    # auth_token = params[:auth_token]
    auth_token = "1f9GE656R1UwHTiyKSLjE7C_d5oxezcRcn6ASutki679gXBsaLti7KHMDPAnFjaP9fLPK6XlSs6G-wsroeUtwrBIUvMXBUkYqJTO4yWVxu239YPgQwFfMc_e9YvOqdoJNsZpamlMSzlNqMB5nMtmXHkuM_Rb6osCXoF0cR7q7a8"

    uri = URI.parse("http://neeraja.housing.com:3030/token-details?auth_token=#{auth_token}")
    response = Net::HTTP.get_response(uri)
    binding.pry
    if response && response.code == "200"
      binding.pry
      token_data = JSON.parse(response.body).symbolize_keys rescue nil
      name = token_data[:user]["facebook_data"]["name"]
      friends_uuids = token_data[:friends]
      client_uuid = token_data[:user]["uuid"]
      user = User.find_by_client_uuid(client_uuid)
      @user_id = user.id if user
      unless user
        flag = User.create(name: name, client_uuid: client_uuid)
        @user_id = flag.id
        pp flag
      end
      @friends = User.where(client_uuid: friends_uuids).pluck(:id) rescue []
    else
      render nothing: true, status: :unauthorized
    end
  end
  
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
    @user_id
  end
  
  def get_my_friends
    [1,2,3,4,5] #list of friend_ids
    @friends
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