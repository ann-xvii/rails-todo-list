class UserSessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(email: params[:email])
  	if user && user.authenticate(params[:password])
  		#set session variable user_id to the @user's id
  		# we store the currently logged in user's id in our rails session
	  	session[:user_id] = user.id
	  	flash[:success] = "Thanks for logging in!"
	  	redirect_to todo_lists_path
  	else
  		flash[:error] = "There was a problem logging in. Please check our email and password."
  		render action: 'new'
  	end

  end
end
