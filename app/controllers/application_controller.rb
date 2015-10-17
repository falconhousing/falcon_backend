class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  skip_before_filter :verify_authenticity_token

  PERMISSION = true

  before_filter do |controller|
    if PERMISSION
      validate_session
    end
  end

  def validate_session
    auth_token = params[:login_auth_token]
    if params[:source] == "web"
      auth_token ||= "STU4Qh7UWQgUm341caUB0tC4hzLMOQd2I_ZH4ZPKfDqYSKcXIg_qXS1qDRHImjVD2f6tSjk8l8muDczdcd-IYAA5gP43h2bfZFro1fCjkDhpYvu1srh4w7oLsQImDA24fETPqgIyObovi2AEYPezGWLvJoDpkS4YSBIfQt8z5ZY"
    end
    
    uri = URI.parse("http://neeraja.housing.com:3030/token-details?auth_token=#{auth_token}")
    response = Net::HTTP.get_response(uri)
    if response && response.code == "200"
      token_data = JSON.parse(response.body).symbolize_keys rescue nil
      name = token_data[:user]["facebook_data"]["name"]
      friends_uuids = token_data[:friends]
      client_uuid = token_data[:user]["uuid"]
      @user = User.find_by_client_uuid(client_uuid)
      @user_id = @user.id if @user
      unless @user
        pic = token_data[:user]["profile_picture_url"]
        @user = User.create(name: name, client_uuid: client_uuid,picture: pic)
        @user_id = @user.id
      end
      @friends = User.where(client_uuid: friends_uuids).pluck(:id) rescue []
    else
      render nothing: true, status: :unauthorized
    end
  end
  
end
