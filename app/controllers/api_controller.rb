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
  
  def results
    posts = get_audios params,current_user_id,get_my_friends
    render json: posts
  end

   def grouped_feed current_user_id,get_my_friends
    posts = get_grouped_audios params
    render json: posts
  end
    
  def search current_user_id,get_my_friends
    posts = get_user_name_search_result params
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
  
 
  
end
