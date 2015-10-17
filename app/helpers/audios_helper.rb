module AudiosHelper
  VM_ADD = "http://dharmendrav.housing.com:4000"
  RADIUS = 500
  # VM_ADD = "http://neeraja.housing.com:4000"
  
  def add_url posts, audios
    count = 0
    posts.each do |post|
      post["coordinates"] = {:latitude => post["coordinates"].latitude, :longitude => post["coordinates"].longitude}
      post[:audio_url] = VM_ADD + audios[count].audio.url
      post[:views] = view_count
      count+=1
    end
    {:stories => posts}
  end
  
  
  def get_audios params,current_user_id,get_my_friends
    lat, lng = params["latitude"], params["longitude"]
    audios = Audio.scoped
    audios = apply_radius_filter(audios,lat, lng,RADIUS)
    sql = "acl = 'public' OR ( acl = 'friends' and user_id in (?)) OR user_id = ?", get_my_friends, current_user_id
    audios = audios.where(sql)
    audios = audios.joins{user}.select("audios.*,users.id as user_id,users.name, users.picture as user_picture") # all matching posts
    posts = audios.as_json
    add_url(posts, audios)
  end
  
  def get_grouped_audios params,current_user_id,get_my_friends
    audios = get_audios(params,current_user_id,get_my_friends)[:stories]
    grouped = {}
    g_array = []
    audios.each do |audio|
      hash = audio.except("user_id", "name")
      if grouped.has_key? audio["user_id"]
        grouped[audio["user_id"]]["stories"].push(hash)
      else
        grouped[audio["user_id"]] = {"stories" => [], "name" => audio["name"], "user_id" => audio["user_id"], "user_picture" => audio["user_picture"]}
        grouped[audio["user_id"]]["stories"].push(hash)
      end
    end
    grouped.keys.each do |k|
      g_array.push(grouped[k])
    end
    {:user_audios => g_array}
  end
  
  
  def get_user_name_search_result params, current_user_id, get_my_friends
    begin
      sql = "acl = 'public' OR ( acl = 'friends' and user_id in (?)) OR user_id = ?", get_my_friends, current_user_id
      audios = Audio.joins{user}.where("name like ?", "%#{params[:q]}%").where(sql).select("audios.*, users.id as user_id,users.name, users.picture as user_picture")
      posts = audios.as_json
      add_url(posts, audios)
    rescue
      audios = []
      {:stories => audios}
    end
  end
  
  
  private

  def apply_radius_filter(audios, lat, lng, radius)
    lat_lng = [lat, lng]
    if lat_lng.length == 2
      sql_args = (lat_lng.reverse + [radius])
      point_circle = "ST_Transform(ST_Buffer(ST_Transform(ST_SetSRID(ST_MakePoint(%s, %s), 4326), 3785), %s), 4326)" % sql_args
      audios = audios.where("st_intersects(%s, audios.coordinates)" % point_circle)
    end
    return audios
  end

  def view_count
    (1..1000).to_a.sample
  end
  
end
