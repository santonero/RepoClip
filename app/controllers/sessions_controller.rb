class SessionsController < ApplicationController
  def new
  end

  def create
    if user = User.authenticate_by(email: params[:account], password: params[:password]) || user = User.authenticate_by(username: params[:account], password: params[:password])
      login user
      redirect_to root_path(format: :html), notice: "Logged in."
    else
      flash[:alert] = "Invalid username or password."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    logout
    redirect_to root_path(format: :html), notice: "Logged out."
  end
end
