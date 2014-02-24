require 'json'

class UserController < ApplicationController
  def login
    fb_user_data = params[:fb_user_data]
    user = User.find_by_fb_id(fb_user_data[:id])
    if(!user) then
      user = User.new
      user.first_name = fb_user_data[:first_name]
      user.last_name = fb_user_data[:last_name]
      user.fb_id = fb_user_data[:id]
      user.rating_score = 0
      user.save
    end
    session[:fb_id] = fb_user_data[:id]
    render nothing: true
  end

  def logout
    session.clear
    render nothing: true
  end

  def profile
    curr_user = params[:id]
    #@user2 = User.where("id = ?", params[:id])
    @user2 = User.find_by id: curr_user
    reviews_array = Rating.where("user_id = ?", curr_user)
    #want to get name of restuarant, item_name
    @review_display_info = []
    reviews_array.each do |review|
      info = []
      item = Food.find(review.ratable_id)
      restaurant = Restaurant.find(item.restaurant_id)
      restaurant_name = restaurant.name
      item_name = item.dish_name
      info.push(item_name)
      info.push([restaurant_name, item.restaurant_id])
      info.push(review.score)
      info.push(review.comment)
      @review_display_info.push(info)
    end
  end

end