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
    @user = User.find_by_id params[:id]
    if @user.nil?
      raise ActionController::RoutingError.new('No such user')
    end
    
    @reviews = Rating.where(user_id: @user.id)
    @favorites = @reviews.order('score').reverse.first(3)
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
