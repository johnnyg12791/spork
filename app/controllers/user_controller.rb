class UserController < ApplicationController
  def login

  end

  def main_page
  	data = params[:first_name]#user_data]
  	users = User.where("fb_id = ?", params[:userID])
  	if(users.length == 0)
  		@user = User.new(:first_name => params[:first_name], :last_name => params[:last_name], :fb_id => params[:userID])
  		@user.save(:validate => false)
  	else
  		@user = users
  	end
  	
#  	render :nothing => true
  	#redirect_to(:controller => 'user', :action => 'mainPage') #+ String(@user.id))

  end

end
