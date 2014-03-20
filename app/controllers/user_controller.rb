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
    session[:user_id] = user.id
    session[:first_name] = user.first_name
    session[:fb_id] = user.fb_id
    render nothing: true
  end

  def logout
    session.clear
    render nothing: true
  end

  def profile
    curr_user = params[:id]
    #@user2 = User.where("id = ?", params[:id])
    @user = User.find_by id: curr_user
    reviews_array = Rating.where("user_id = ?", curr_user)
    #want to get name of restuarant, item_name
    reviews_array.sort_by{|review| review.date_time}.reverse
    @review_display_info = []
    reviews_array.each do |review|
      info = []
      item = Food.find(review.ratable_id)
      restaurant = Restaurant.find(item.restaurant_id)
      restaurant_name = restaurant.name
      item_name = item.dish_name
      item_id = item.id
      info.push(item_name)
      info.push([restaurant_name, item.restaurant_id])
      info.push(review.score)
      info.push(review.comment)
      info.push(item_id)
      @review_display_info.push(info)

    # sorted_reviews = @review_display_info.sort_by{|review| review[2]}
    # @favorites = sorted_reviews.first(3)
    sorted_reviews = reviews_array.sort_by{|review| review.score}
    @favorites=sorted_reviews.first(3)

  end


    def update
      @user = User.find(params[:id])
      @user.first_name = params[:user][:first_name]
      @user.last_name = params[:user][:last_name]
      if @user.save then
        redirect_to(:action => :profile)
      else
        render(:action => :edit)
      end
    end #end of update


    def create
      @var1 = "var1"
    end


    def new
      @user = User.new(params[:user])
      if @user.save then
        redirect_to(:action => :show)
      else
        render(:action => :edit)
      end
    end #end of new

  end #end of class

end #end of file