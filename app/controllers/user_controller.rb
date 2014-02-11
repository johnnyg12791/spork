class UserController < ApplicationController
  def login

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
