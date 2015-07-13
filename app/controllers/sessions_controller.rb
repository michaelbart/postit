class SessionsController < ApplicationController

  def new
    if logged_in?
      flash[:error] = "You are already logged in."
      redirect_to root_path
    end
  end

  def create
    # authenticate user => user.authenticate('password')
    # 1. get the user obj
    # 2. see if password matches
    # 3. if so, log in
    # 4. if not, error message

    user = User.find_by(username: params[:username])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Welcome #{user.username}, you've logged in!"
      redirect_to root_path
    else
      flash[:error] = "There is something wrong with your username or password."
      redirect_to login_path
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "You've logged out."
    redirect_to root_path
  end
end
