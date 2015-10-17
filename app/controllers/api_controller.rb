class ApiController < ApplicationController
  include AudiosHelper
  
  def results
    posts = get_audios params
    render json: posts
  end

  def grouped_feed
    posts = get_grouped_audios params
    render json: posts
  end
    
  def search
    posts = get_user_name_search_result params
    render json: posts
  end
  
end