class ApiController < ApplicationController
  include AudiosHelper
  
  def results
    posts = get_audios params,current_user_id,get_my_friends
    render json: posts
  end

   def grouped_feed 
    posts = get_grouped_audios params,current_user_id,get_my_friends
    render json: posts
  end
    
  def search
    posts = get_user_name_search_result params, current_user_id, get_my_friends
    render json: posts
  end
  
 
  def current_user
    render json: @user
  end
  
  private

  def current_user_id
    @user_id
  end

  def get_my_friends
    @friends
  end
  
end
