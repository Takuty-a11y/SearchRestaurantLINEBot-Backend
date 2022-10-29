class Api::V1::WebSearchController < ApplicationController
  include Commons
  
  def index
    query = {
      'key' => ENV['HOTPEPPER_APPID'],
      'count' => 50,
      'format' => 'json'
    }
    query['large_area'] = params[:large_area]
    query['middle_area'] = params[:middle_area]
    query['keyword'] = params[:keyword]
    query['genre'] = params[:genre]
    query['budget'] = params[:budget]
    query['order'] = params[:sort]
    query['start'] = (params[:page].to_i * 50) + 1

    response = get_restaurants(query)
    if response.include?('error')
      render json: response['error'], status: :bad_request
    else
      render json: response['shop'], status: :ok
    end
  end

  def largearea
    query = {
      'key' => ENV['HOTPEPPER_APPID'],
      'format' => 'json'
    }
    response = get_largeareas(query)
    if response.include?('error')
      render json: response['error'], status: :bad_request
    else
      render json: response['large_area'], status: :ok
    end
  end

  def middlearea
    query = {
      'key' => ENV['HOTPEPPER_APPID'],
      'format' => 'json'
    }
    query['large_area'] = params[:largeareaCode]

    response = get_middleareas(query)
    if response.include?('error')
      render json: response['error'], status: :bad_request
    else
      render json: response['middle_area'], status: :ok
    end
  end
end
